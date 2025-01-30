//
//  Service.swift
//  MVCMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation

class CountryServices: CountryNetworkProtocol {
    static func fetchCountriesFromAPI(
        sportType: SportType, completionHandler: @escaping (CountryResult?) -> Void
    ) {
        
        let targetEndPoint = EndPoints.getTargetSportEndPoint(targetSport: sportType)
        let url = URL(
            string: targetEndPoint.appending(EndPointKey.met).appending(
                "Countries"))
        guard let newUrl = url else { return }
        let request = URLRequest(url: newUrl)

        let seesion = URLSession(configuration: .default)
        let task = seesion.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(
                    CountryResult.self, from: data)
                completionHandler(result)
            } catch {
                print(error.localizedDescription)
                let result = CountryResult()
                result.success = 0
                completionHandler(result)
            }

        }
        task.resume()
    }
}
