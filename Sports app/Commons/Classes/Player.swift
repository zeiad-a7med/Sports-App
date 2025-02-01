//
//  Player.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import Foundation
struct Player: Codable {
    let playerkey: Int?
    let playerImage: String?
    let playerName: String?
    let playerNumber: String?
    let playerCountry: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerBirthdate: String?

    enum CodingKeys: String, CodingKey {
        case playerkey = "player_key"
        case playerImage = "player_image"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerBirthdate = "player_birthdate"
    }
}
                   
