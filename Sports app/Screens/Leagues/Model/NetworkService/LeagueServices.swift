//
//  Service.swift
//  MVCMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation

class LeagueServices: LeagueNetworkProtocol {
    static func fetchLeaguesFromAPI(
        sportType: SportType, countryId: Int?,
        completionHandler: @escaping (LeagueResult?) -> Void
    ) {

        var targetEndPoint = EndPoints.getTargetSportEndPoint(
            targetSport: sportType)
        targetEndPoint=targetEndPoint.appending(EndPointKey.met).appending(
            "Leagues"
        )
        if(countryId != nil){
            targetEndPoint=targetEndPoint.appending(EndPointKey.countryId).appending(String(countryId!))
        }
        
        let url = URL(
            string: targetEndPoint)
        guard let newUrl = url else { return }
        let request = URLRequest(url: newUrl)

        let seesion = URLSession(configuration: .default)
        let task = seesion.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(
                    LeagueResult.self, from: data)
                completionHandler(result)
            } catch {
                print(error.localizedDescription)
                let result = LeagueResult()
                result.success = 0
                completionHandler(result)
            }

        }
        task.resume()
    }
}
