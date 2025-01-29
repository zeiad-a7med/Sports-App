//
//  ProductResult.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//

import Foundation

struct League : Decodable{
    var leaguekey:Int?
    var countrykey:String?
    var countryName:String?
    var leagueLogo:String?
    var countryLogo:String?
    enum CodingKeys: String, CodingKey {
        case leaguekey = "league_key"
        case countrykey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}
