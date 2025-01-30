//
//  EndPoints.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//

import Foundation

class EndPoints {
    static let baseUrl = "https://apiv2.allsportsapi.com/"
    static let football =
        "\(baseUrl)football/?\(EndPointKey.apikey)\(Constants.API_KEY)"
    static let basketball =
        "\(baseUrl)basketball/?\(EndPointKey.apikey)\(Constants.API_KEY)"
    static let cricket =
        "\(baseUrl)cricket/?\(EndPointKey.apikey)\(Constants.API_KEY)"
    static let tennis =
        "\(baseUrl)tennis/?\(EndPointKey.apikey)\(Constants.API_KEY)"

    static func getTargetSportEndPoint(targetSport: SportType) -> String {
        switch targetSport {
        case .football:
            return football
        case .basketball:
            return basketball
        case .cricket:
            return cricket
        case .tennis:
            return tennis
        }
    }
}
