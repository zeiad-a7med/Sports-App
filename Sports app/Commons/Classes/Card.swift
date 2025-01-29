//
//  Card.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//
import Foundation
struct Card: Codable {
    let time: String?
    let homeFault: String?
    let card: String?
    let awayFault: String?
    let info: String?
    let homePlayerId: String?
    let awayPlayerId: String?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeFault = "home_fault"
        case card
        case awayFault = "away_fault"
        case info
        case homePlayerId = "home_player_id"
        case awayPlayerId = "away_player_id"
        case infoTime = "info_time"
    }
}
