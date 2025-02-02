//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol FavoriteLeagueLocalServiceProtocol {
    static func fetchLeaguesFromLocalDB(
        completionHandler: @escaping (LocalDBResponse?) -> Void
    )
}
