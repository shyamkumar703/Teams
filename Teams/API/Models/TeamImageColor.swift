//
//  TeamImageColor.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//

import Foundation

struct TeamImageColor: Codable, Identifiable, Equatable {
    var id: String {
        team
    }
    var team: String
    var colors: [TeamColor]
    var imageName: String {
        team.replacingOccurrences(of: " ", with: "_")
    }
    var cityName: String {
        if team.lowercased().contains("portland") {
            return "PORTLAND"
        } else {
            let splitArr = team.split(separator: " ")
            return splitArr[0..<splitArr.count - 1].reduce("", { subRes, curr in
                return subRes + " \(curr)"
            }).uppercased()
        }
    }
    var teamName: String {
        if team.lowercased().contains("portland") {
            return "TRAIL BLAZERS"
        } else {
            return team.split(separator: " ").last?.uppercased() ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case team
        case colors
    }
    
    static func == (lhs: TeamImageColor, rhs: TeamImageColor) -> Bool {
        lhs.id == rhs.id
    }
}

struct TeamColor: Codable {
    var hex: String
    
    enum CodingKeys: String, CodingKey {
        case hex = "HEX"
    }
}
