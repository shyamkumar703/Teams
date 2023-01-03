//
//  Session.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import Foundation

fileprivate var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

fileprivate enum Endpoints: String {
    case colors = "https://nbacolors.com/js/data.json"
    case teams = "https://www.balldontlie.io/api/v1/teams"
    case games = "https://www.balldontlie.io/api/v1/games?per_page=100&seasons[]=2022"
    
    func withAddedParams(bdlId: Int) -> String {
        switch self {
        case .colors, .teams: return rawValue
        case .games:
            // https://www.balldontlie.io/api/v1/games?seasons[]=2022&team_ids[]=10&per_page=100&start_date=2023-01-02
            var startEndpoint = rawValue
            startEndpoint += "&start_date=\(dateFormatter.string(from: Date()))&team_ids[]=\(bdlId)"
            return startEndpoint
        }
    }
}

protocol Session {
    var selectedTeam: Team? { get }
    
    func pickTeamImageColor(tic: TeamImageColor, completion: @escaping () -> Void)
    func loadTeamImageColors(completion: @escaping ([TeamImageColor]) -> Void)
    func loadCombinedTeamObjects(completion: @escaping ([Team]) -> Void)
    func loadGamesForSelectedTeam(completion: @escaping ([Game]) -> Void)
}

class SessionManager: Session {
    var dependencies: HasAPI & HasStorage
    var selectedTeamImageColor: TeamImageColor?
    var selectedTeam: Team?
    var teamImageColorCache = [TeamImageColor]()
    var bdlTeamObjectsCache = [BDLTeam]()
    var teamCache = [Team]()
    var gameCache = [Game]()
    
    init(dependencies: HasAPI & HasStorage) {
        self.dependencies = dependencies
        self.selectedTeamImageColor = dependencies.storage.read(type: TeamImageColor.self, from: .selectedTeamImageColor)
        self.selectedTeam = dependencies.storage.read(type: Team.self, from: .selectedTeam)
        self.teamImageColorCache = dependencies.storage.read(type: [TeamImageColor].self, from: .teamImageColors)
        self.bdlTeamObjectsCache = dependencies.storage.read(type: [BDLTeam].self, from: .bdlTeams)
        self.teamCache = dependencies.storage.read(type: [Team].self, from: .teams)
        self.gameCache = dependencies.storage.read(type: [Game].self, from: .games)
    }
    
    func pickTeamImageColor(tic: TeamImageColor, completion: @escaping () -> Void) {
        self.selectedTeamImageColor = tic
        dependencies.storage.save(tic, with: .selectedTeamImageColor)
        loadCombinedTeamObjects { _ in completion() }
    }
    
    func loadTeamImageColors(completion: @escaping ([TeamImageColor]) -> Void) {
        if !teamImageColorCache.isEmpty {
            completion(teamImageColorCache)
        } else {
            dependencies.api.call(
                urlPath: Endpoints.colors.rawValue,
                responseType: [TeamImageColor].self,
                storageKey: .teamImageColors
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let teamImages):
                    self.teamImageColorCache = teamImages
                    completion(teamImages)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }
    
    func loadBDLTeamObjects(completion: @escaping ([BDLTeam]) -> Void) {
        if !bdlTeamObjectsCache.isEmpty {
            completion(bdlTeamObjectsCache)
        } else {
            dependencies.api.call(
                urlPath: Endpoints.teams.rawValue,
                responseType: BDLTeamResponse.self,
                storageKey: nil
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let teams):
                    self.bdlTeamObjectsCache = teams.data
                    completion(teams.data)
                    self.dependencies.storage.save(teams.data, with: .bdlTeams)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }
    
    func loadCombinedTeamObjects(completion: @escaping ([Team]) -> Void) {
        if !teamCache.isEmpty {
            completion(teamCache)
        } else {
            loadTeamImageColors { [weak self] teamImageColors in
                self?.loadBDLTeamObjects { [weak self] bdlTeams in
                    guard let self = self else { return }
                    let teamObjects = self.createTeamObjects(from: teamImageColors, and: bdlTeams)
                    self.teamCache = teamObjects
                    self.dependencies.storage.save(teamObjects, with: .teams)
                    completion(teamObjects)
                }
            }
        }
    }
    
    func loadGamesForSelectedTeam(completion: @escaping ([Game]) -> Void) {
        guard let selectedTeam = selectedTeam else {
            completion([])
            return
        }
        guard gameCache.isEmpty else {
            completion(gameCache)
            return
        }
        dependencies.api.call(
            urlPath: Endpoints.games.withAddedParams(bdlId: selectedTeam.id),
            responseType: GameListResponse.self,
            storageKey: nil
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let gameListResponse):
                let games = gameListResponse.data
                    .compactMap({ self.bdlGameToGame(bdlGame: $0) })
                    .sorted()
                    .filter({ $0.date.composed >= Date().composed })
                self.gameCache = games
                completion(games)
                self.dependencies.storage.save(games, with: .games)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    private func bdlGameToGame(bdlGame: GameResponse) -> Game? {
        guard !teamCache.isEmpty else { return nil }
        guard let homeTeam = teamCache.filter({ $0.id == bdlGame.homeTeam.id }).first,
              let awayTeam = teamCache.filter({ $0.id == bdlGame.visitorTeam.id }).first else {
            return nil
        }
        return Game(bdlGame: bdlGame, homeTeam: homeTeam, awayTeam: awayTeam, dateFormatter: dateFormatter)
    }
    
    private func createTeamObjects(from tic: [TeamImageColor], and bdl: [BDLTeam]) -> [Team] {
        return combine(tic, bdl).compactMap({ (zippedTic, zippedBdl) in
            if zippedTic.teamName.trimmingCharacters(in: .whitespaces).lowercased() == zippedBdl.name.trimmingCharacters(in: .whitespaces).lowercased() {
                let team = Team(bdlTeam: zippedBdl, teamImageColor: zippedTic)
                if zippedTic == selectedTeamImageColor {
                    selectedTeam = team
                    dependencies.storage.save(team, with: .selectedTeam)
                }
                return team
            } else {
                return nil
            }
        })
    }
    
    private func combine<T, U>(_ array1: [T], _ array2: [U], partial: [(T, U)] = []) -> [(T, U)] {
        if array1.isEmpty {
            return partial
        }
        var array1 = array1
        let currentPivot = array1.removeFirst()
        var resultFromCurrentPivot = [(T, U)]()
        for el in array2 {
            resultFromCurrentPivot.append((currentPivot, el))
        }
        return combine(array1, array2, partial: partial + resultFromCurrentPivot)
    }
}
