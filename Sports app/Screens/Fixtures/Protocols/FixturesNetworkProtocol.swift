//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol FixturesNetworkProtocol {
    static func fetchFixturesFromAPI(
        sportType: SportType, league: League,
        completionHandler: @escaping (FixturesResult?) -> Void
    )
    static func fetchTeamsFromAPI(
        sportType: SportType, league: League,
        completionHandler: @escaping (TeamsResult?) -> Void
    )
}
