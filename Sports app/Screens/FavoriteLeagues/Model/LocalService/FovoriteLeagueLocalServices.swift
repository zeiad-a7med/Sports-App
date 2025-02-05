//
//  Service.swift
//  MVCMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation

class FovoriteLeagueLocalServices: FavoriteLeagueLocalServiceProtocol {
    static func fetchLeaguesFromLocalDB(completionHandler: @escaping (LocalDBResponse) -> Void) {
        let response = DBManager.shared.getFavoriteLeaguesFromLocalDB()
        completionHandler(response)
    }
}
