//
//  ProductResult.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//

import Foundation
import CoreData
struct League : Decodable{
    var leaguekey:Int?
    var countrykey:Int?
    var countryName:String?
    var leagueLogo:String?
    var countryLogo:String?
    var leagueName:String?
    var leagueYear:String?
    var sportType:String?
    enum CodingKeys: String, CodingKey {
        case leaguekey = "league_key"
        case countrykey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case leagueName = "league_name"
        case leagueYear = "league_year"
        case sportType = "sport_type"
    }
    
    static func leagueFromNSManagedObject(object : NSManagedObject)->League{
        var league = League()
        league.leaguekey = object.value(forKey: "leaguekey") as? Int
        league.leagueName = object.value(forKey: "leagueName") as? String
        league.leagueYear = object.value(forKey: "leagueYear") as? String
        league.leagueLogo = object.value(forKey: "leagueLogo") as? String
        league.countrykey = object.value(forKey: "countrykey") as? Int
        league.countryName = object.value(forKey: "countryName") as? String
        league.countryLogo = object.value(forKey: "countryLogo") as? String
        league.sportType = object.value(forKey: "sportType") as? String
        return league
    }
}
