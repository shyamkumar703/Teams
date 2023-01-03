//
//  TeamPickerCell.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//

import SwiftUI



struct TeamPickerCell: View {
    @State var iconSize: CGFloat = 60
    @State var team: TeamImageColor
    var body: some View {
        HStack {
            Image(team.imageName)
                .resizable()
                .frame(width: 60, height: 60)
            PrimarySecondaryText(primary: team.cityName, secondary: team.teamName)
        }
        .listRowSeparator(.hidden, edges: .all)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TeamPickerCell_Previews: PreviewProvider {
    static var previews: some View {
        TeamPickerCell(
            team: TeamImageColor(
                team: "Golden State Warriors",
                colors: [
                    TeamColor(hex: "#000000")
                ]
            )
        )
    }
}
