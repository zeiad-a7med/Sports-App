//
//  Player.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import Foundation
struct Player: Codable {
    let player: String?
    let playerNumber: Int?
    let playerPosition: Int?
    let playerCountry: String?
    let playerKey: Int?

    enum CodingKeys: String, CodingKey {
        case player
        case playerNumber = "player_number"
        case playerPosition = "player_position"
        case playerCountry = "player_country"
        case playerKey = "player_key"
    }
}
