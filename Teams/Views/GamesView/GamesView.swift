//
//  GamesView.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import SwiftUI

struct GamesView: View {
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let team = viewModel.team {
                GamesViewHeader(team: team)
                    .padding(.horizontal, 4)
            }
            if let game = viewModel.highlightedGame {
                if game.hasStarted {
                    Text("ONGOING")
                        .font(.mediumSubtitle)
                        .padding(.horizontal, 12)
                        .padding(.top)
                    GameView(game: game)
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                } else {
                    Text("UPCOMING")
                        .font(.mediumSubtitle)
                        .padding(.horizontal, 12)
                        .padding(.top)
                    UpcomingGameView(game: game)
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                }
            }
            Text("SCHEDULE")
                .font(.mediumSubtitle)
                .padding(.horizontal, 12)
                .padding(.top)
            List {
                ForEach(viewModel.upcomingSchedule) { game in
                    UpcomingScheduleView(game: game)
                        .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                }
            }
            .listStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { viewModel.loadData() }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(viewModel: GamesView.ViewModel(dependencies: Dependencies()))
    }
}

extension GamesView {
    class ViewModel: ObservableObject {
        @Published var highlightedGame: Game?
        @Published var upcomingSchedule = [Game]()
        @Published var team: Team?
        private var dependencies: AllDependencies
        
        init(dependencies: AllDependencies) {
            self.dependencies = dependencies
        }
        
        func loadData() {
            self.team = dependencies.session.selectedTeam
            dependencies.session.loadGamesForSelectedTeam { games in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.highlightedGame = games.first
                    self.upcomingSchedule = Array(games.dropFirst())
                }
            }
        }
    }
}
