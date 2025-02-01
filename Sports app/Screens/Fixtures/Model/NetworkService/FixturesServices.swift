//
//  Service.swift
//  MVCMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation

class FixturesServices: FixturesNetworkProtocol {
    
    
    static func fetchFixturesFromAPI(
        sportType: SportType, league: League,
        completionHandler: @escaping (FixturesResult?) -> Void
    ) {

        var targetEndPoint = EndPoints.getTargetSportEndPoint(
            targetSport: sportType)
        targetEndPoint=targetEndPoint.appending(EndPointKey.met).appending(
            "Fixtures"
        )
        .appending(EndPointKey.leagueId).appending("\(league.leaguekey!)")
        .appending(EndPointKey.from).appending("2024-02-01")
        .appending(EndPointKey.to).appending("2025-05-01")
        let url = URL(
            string: targetEndPoint)
        guard let newUrl = url else { return }
        let request = URLRequest(url: newUrl)

        let seesion = URLSession(configuration: .default)
        let task = seesion.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(
                    FixturesResult.self, from: data)
                completionHandler(result)
            } catch {
                print(error.localizedDescription)
                let result = FixturesResult()
                result.success = 0
                completionHandler(result)
            }

        }
        task.resume()
    }
    
    static func fetchTeamsFromAPI(sportType: SportType, league: League, completionHandler: @escaping (TeamsResult?) -> Void) {
        var targetEndPoint = EndPoints.getTargetSportEndPoint(
            targetSport: sportType)
        targetEndPoint=targetEndPoint.appending(EndPointKey.met).appending(
            "Teams"
        )
        .appending(EndPointKey.leagueId).appending("\(league.leaguekey!)")
        let url = URL(
            string: targetEndPoint)
        guard let newUrl = url else { return }
        let request = URLRequest(url: newUrl)

        let seesion = URLSession(configuration: .default)
        let task = seesion.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(
                    TeamsResult.self, from: data)
                completionHandler(result)
            } catch {
                print(error.localizedDescription)
                let result = TeamsResult()
                result.success = 0
                completionHandler(result)
            }

        }
        task.resume()
    }
}
