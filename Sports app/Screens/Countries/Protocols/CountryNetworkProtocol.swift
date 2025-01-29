//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol CountryNetworkProtocol {
    static func fetchCountriesFromAPI(
        sportName: String, completionHandler: @escaping (CountryResult?) -> Void
    )
}
