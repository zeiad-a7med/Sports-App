//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol LeagueNetworkProtocol {
    static func fetchLeaguesFromAPI(
        sportType: SportType, countryId: Int?,
        completionHandler: @escaping (LeagueResult?) -> Void
    )
}
