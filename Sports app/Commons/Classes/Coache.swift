//
//  Coache.swift
//  Sports app
//
//  Created by Zeiad on 01/02/2025.
//
import Foundation

class Coache: Codable {
    let coachName: String?
    let coachCountry: String?
    let coachAge: Int?

    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
        case coachCountry = "coach_country"
        case coachAge = "coach_age"
    }
}
