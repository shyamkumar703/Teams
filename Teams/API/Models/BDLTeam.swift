//
//  BDLTeam.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import Foundation

struct BDLTeam: Identifiable, Codable {
    var id: Int
    var abbreviation: String
    var city: String
    var conference: String
    var division: String
    var fullName: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case abbreviation
        case city
        case conference
        case division
        case fullName = "full_name"
        case name
    }
}

struct BDLTeamResponse: Codable {
    var data: [BDLTeam]
}
