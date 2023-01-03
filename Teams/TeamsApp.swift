//
//  TeamsApp.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//


import SwiftUI

@main
struct TeamsApp: App {
    var dependencies = Dependencies()
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            if dependencies.session.selectedTeam != nil {
                GamesView(
                    viewModel: GamesView.ViewModel(
                        dependencies: dependencies
                    )
                ).preferredColorScheme(.light)
            } else {
                ContentView(
                    viewModel: ContentView.ViewModel(
                        dependencies: Dependencies()
                    )
                ).preferredColorScheme(.light)
            }
        }
    }
}
