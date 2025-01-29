//
//  Goaa.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import Foundation

struct Goalscorer: Codable {
    let time: String?
    let homeScorer: String?
    let homeScorerId: String?
    let homeAssist: String?
    let homeAssistId: String?
    let score: String?
    let awayScorer: String?
    let awayScorerId: String?
    let awayAssist: String?
    let awayAssistId: String?
    let info: String?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeScorer = "home_scorer"
        case homeScorerId = "home_scorer_id"
        case homeAssist = "home_assist"
        case homeAssistId = "home_assist_id"
        case score
        case awayScorer = "away_scorer"
        case awayScorerId = "away_scorer_id"
        case awayAssist = "away_assist"
        case awayAssistId = "away_assist_id"
        case info
        case infoTime = "info_time"
    }
}
