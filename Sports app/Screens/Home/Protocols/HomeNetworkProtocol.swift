//
//  HomeNetworkProtocol.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

protocol HomeNetworkProtocol{
    static func fetchCountriesFromAPI(completionHandler : @escaping(HomeResult?) -> Void)
}
