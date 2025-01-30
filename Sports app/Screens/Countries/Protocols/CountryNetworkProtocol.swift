//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol CountryNetworkProtocol {
    static func fetchCountriesFromAPI(
        sportType: SportType, completionHandler: @escaping (CountryResult?) -> Void
    )
}
