//
//  ContentView.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var showContent: Bool = true
    @State var team: TeamImageColor?
    
    var body: some View {
        if showContent {
            VStack {
                Text("PICK YOUR TEAM")
                    .font(.mediumTitleSmall)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 12)
                
                List {
                    ForEach(viewModel.teams) { team in
                        TeamPickerCell(team: team)
                            .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                            .onTapGesture {
                                UIImpactFeedbackGenerator().impactOccurred()
                                viewModel.pickTeam(tic: team)
                                withAnimation {
                                    self.team = team
                                    showContent.toggle()
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            .onAppear {
                self.viewModel.loadTeams()
            }
        } else {
            if let team = team {
                TeamPickedView(team: team, viewModel: viewModel.teamPickedViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentView.ViewModel(
                dependencies: Dependencies()
            )
        )
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var teams = [TeamImageColor]()
        var dependencies: AllDependencies
        var teamPickedViewModel: TeamPickedView.ViewModel {
            TeamPickedView.ViewModel(dependencies: dependencies)
        }
        
        init(dependencies: AllDependencies) {
            self.dependencies = dependencies
        }
        
        func loadTeams() {
            dependencies.session.loadTeamImageColors { [weak self] teamColors in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.teams = teamColors
                }
            }
        }
        
        func pickTeam(tic: TeamImageColor) {
            dependencies.session.pickTeamImageColor(tic: tic) { [weak self] in
                self?.dependencies.session.loadGamesForSelectedTeam { _ in }
            }
        }
    }
}
