//
//  Lineups.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import Foundation
struct Lineups: Codable {
    let homeTeam: Lineup?
    let awayTeam: Lineup?

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

struct Lineup: Codable {
    let startingLineups: [Player]?
    let substitutes: [Player]?

    enum CodingKeys: String, CodingKey {
        case startingLineups = "starting_lineups"
        case substitutes
    }
}
