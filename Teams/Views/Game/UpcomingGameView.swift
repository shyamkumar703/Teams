//
//  UpcomingGameView.swift
//  Teams
//
//  Created by Shyam Kumar on 1/1/23.
//

import SwiftUI

struct UpcomingGameView: View {
    @State var game: Game
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .circular)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: game.visitorTeam.teamImageColor.colors[0].hex) ?? .black, location: 0.5),
                                .init(color: Color(hex: game.homeTeam.teamImageColor.colors[0].hex) ?? .black, location: 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text(game.status)
                    .foregroundColor(.white)
                    .font(.boldTitleMediumSmall)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 8))
            }
            VStack(alignment: .center, spacing: 2) {
                Image(game.visitorTeam.teamImageColor.imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .center, spacing: 6) {
                    Text(game.visitorTeam.bdlTeam.abbreviation)
                        .foregroundColor(.white)
                        .font(.mediumSubtitle)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 6) {
                    Text(game.homeTeam.bdlTeam.abbreviation)
                        .foregroundColor(.white)
                        .font(.mediumSubtitle)
                        .multilineTextAlignment(.center)
                }
                Image(game.homeTeam.teamImageColor.imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
//            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .frame(width: UIScreen.main.bounds.width - 24, height: UIScreen.main.bounds.height * 0.2)
    }
}

//struct UpcomingGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpcomingGameView()
//    }
//}
