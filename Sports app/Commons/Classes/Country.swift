//
//  ProductResult.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//

import Foundation
struct Country : Decodable{
    var countrykey:Int?
    var countryName:String?
    var countryIso2:String?
    var countryLogo:String?
    enum CodingKeys: String, CodingKey {
        case countrykey = "country_key"
        case countryName = "country_name"
        case countryIso2 = "country_iso2"
        case countryLogo = "country_logo"
    }
}
