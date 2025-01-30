//
//  Router.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//
import UIKit

class Router {

    static func goToHomePage(from: UIViewController) {
        let homeVC =
            from.storyboard?.instantiateViewController(
                identifier: RouteString.HomePage) as! HomeViewController
        from.navigationController?.pushViewController(homeVC, animated: true)
    }
    static func goToCountriesPage(from: UIViewController, sportType: SportType)
    {
        let countriesVC =
            from.storyboard?.instantiateViewController(
                identifier: RouteString.CountriesPage)
            as! CountriesTableViewController
        countriesVC.sportType = sportType
        from.navigationController?.pushViewController(
            countriesVC, animated: true)
    }
    static func goToLeaguesPage(
        from: UIViewController, sportType: SportType, countryId: Int?
    ) {
        let leaguesVC =
            from.storyboard?.instantiateViewController(
                identifier: RouteString.LeaguesPage)
            as! LeaguesTableViewController
        leaguesVC.sportType = sportType
        leaguesVC.countryId = countryId
        from.navigationController?.pushViewController(leaguesVC, animated: true)
    }
}

class RouteString {
    static let HomePage = "home"
    static let CountriesPage = "countries"
    static let LeaguesPage = "leagues"
}
