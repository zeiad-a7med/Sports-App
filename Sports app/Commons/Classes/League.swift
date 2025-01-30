//
//  ProductResult.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//

import Foundation

struct League : Decodable{
    var leaguekey:Int?
    var countrykey:Int?
    var countryName:String?
    var leagueLogo:String?
    var countryLogo:String?
    var leagueName:String?
    var leagueYear:String?
    enum CodingKeys: String, CodingKey {
        case leaguekey = "league_key"
        case countrykey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case leagueName = "league_name"
        case leagueYear = "league_year"
    }
}
