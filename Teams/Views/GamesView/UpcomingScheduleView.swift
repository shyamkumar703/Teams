//
//  UpcomingScheduleView.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import SwiftUI

struct UpcomingScheduleView: View {
    @State var game: Game
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()

    var body: some View {
        ZStack {
            PrimarySecondaryText(
                primary: dateFormatter.string(from: game.date),
                secondary: "· \(game.status.trimmingCharacters(in: .whitespaces))",
                font: .mediumTitleSmall,
                primaryColor: .black,
                secondaryColor: .secondaryTextOnWhite
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                VStack(alignment: .leading) {
                    Image(game.visitorTeam.teamImageColor.imageName)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .leading)
                    Text(game.visitorTeam.teamImageColor.teamName)
                        .font(.mediumTitleSmall)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Image(game.homeTeam.teamImageColor.imageName)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .trailing)
                    Text(game.homeTeam.teamImageColor.teamName)
                        .font(.mediumTitleSmall)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listRowSeparator(.hidden, edges: .all)
    }
}

//struct UpcomingScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpcomingScheduleView()
//    }
//}
