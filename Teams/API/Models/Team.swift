//
//  Team.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import Foundation

struct Team: Identifiable, Codable {
    var bdlTeam: BDLTeam
    var teamImageColor: TeamImageColor
    var id: Int {
        bdlTeam.id
    }
}
