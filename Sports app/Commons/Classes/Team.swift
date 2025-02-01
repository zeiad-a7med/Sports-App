//
//  Card.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//
import Foundation
struct Team: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    let players: [Player]?
    let coaches: [Coache]?
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
        case coaches
    }
}
