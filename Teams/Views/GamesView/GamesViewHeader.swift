//
//  GamesViewHeader.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import SwiftUI

struct GamesViewHeader: View {
    @State var team: Team
    var body: some View {
        HStack {
            Image(team.teamImageColor.imageName)
                .resizable()
                .frame(width: 60, height: 60)
            VStack(spacing: 4) {
                PrimarySecondaryText(primary: team.teamImageColor.cityName, secondary: team.teamImageColor.teamName, textAlignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(team.bdlTeam.conference.uppercased())ERN CONFERENCE")
                    .font(.mediumTitleMediumSmall)
                    .foregroundColor(.secondaryTextOnWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            }
        }
    }
}

//struct GamesViewHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        GamesViewHeader(
//            team: TeamImageColor(
//                team: "Golden State Warriors",
//                colors: [
//                    TeamColor(hex: "#000000")
//                ]
//            )
//        )
//    }
//}
