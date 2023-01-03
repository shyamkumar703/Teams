//
//  Game.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import Foundation

struct GameListResponse: Codable {
    var data: [GameResponse]
}

struct GameResponse: Codable {
    var id: Int
    var date: String
    var homeTeam: BDLTeam // home_team
    var homeTeamScore: Int // home_team_score
    var period: Int
    var postseason: Bool
    var season: Int
    var status: String // Tip time in ET
    var time: String // unsure
    var visitorTeam: BDLTeam // visitor_team
    var visitorTeamScore: Int // visitor_team_score
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case homeTeam = "home_team"
        case homeTeamScore = "home_team_score"
        case period
        case postseason
        case season
        case status
        case time
        case visitorTeam = "visitor_team"
        case visitorTeamScore = "visitor_team_score"
    }
}

struct Game: Comparable, Identifiable, Codable {
    var id: Int
    var date: Date
    var homeTeam: Team
    var homeTeamScore: Int
    var period: Int
    var postseason: Bool
    var season: Int
    var status: String // Tip time in ET
    var time: String // Unsure
    var visitorTeam: Team
    var visitorTeamScore: Int
    var hasStarted: Bool { period != 0 }
    
    init(bdlGame: GameResponse, homeTeam: Team, awayTeam: Team, dateFormatter: DateFormatter) {
        self.id = bdlGame.id
        self.date = dateFormatter.date(from: String(bdlGame.date.split(separator: "T")[0])) ?? Date()
        self.homeTeam = homeTeam
        self.homeTeamScore = bdlGame.homeTeamScore
        self.period = bdlGame.period
        self.postseason = bdlGame.postseason
        self.season = bdlGame.season
        self.status = bdlGame.status
        self.time = bdlGame.time
        self.visitorTeam = awayTeam
        self.visitorTeamScore = bdlGame.visitorTeamScore
    }
    
    static func < (lhs: Game, rhs: Game) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }
}
