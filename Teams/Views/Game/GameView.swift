//
//  GameView.swift
//  Teams
//
//  Created by Shyam Kumar on 1/1/23.
//

import SwiftUI

struct GameView: View {
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
                PrimarySecondaryText(
                    primary: Status(rawValue: game.status)?.primaryText ?? "",
                    secondary: String(game.time.split(separator: " ")[1]),
                    font: .boldTitleMediumSmall,
                    textAlignment: .leading,
                    primaryColor: .secondaryTextOnBlack,
                    secondaryColor: .white
                )
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .center, spacing: 8) {
                    Text(game.visitorTeam.bdlTeam.abbreviation)
                        .foregroundColor(.white)
                        .font(.mediumTitleSmall)
                        .multilineTextAlignment(.center)
                    Text("\(game.visitorTeamScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                VStack(alignment: .center, spacing: 8) {
                    Text("\(game.homeTeamScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text(game.homeTeam.bdlTeam.abbreviation)
                        .foregroundColor(.white)
                        .font(.mediumTitleSmall)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .frame(width: UIScreen.main.bounds.width - 24, height: UIScreen.main.bounds.height * 0.2)
    }
}

// MARK: - Helpers
extension GameView {
    enum Status: String {
        case firstQtr = "1st Qtr"
        case secondQtr = "2nd Qtr"
        case thirdQtr = "3rd Qtr"
        case fourthQtr = "4th Qtr"
        case halftime = "Halftime"
        case final = "Final"
        
        var primaryText: String {
            switch self {
            case .firstQtr: return "1ST "
            case .secondQtr: return "2ND "
            case .thirdQtr: return "3RD "
            case .fourthQtr: return "4TH "
            case .halftime: return "HALF"
            case .final: return "FINAL"
            }
        }
    }
}

//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView()
//    }
//}
