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
                identifier: RouteString.HomePage)
        as? UIViewController
        from.navigationController?.pushViewController(homeVC!, animated: true)
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
    static func goToFixturesPage(
        from: UIViewController, sportType: SportType, league: League
    ) {
        let fixturesVC =
            from.storyboard?.instantiateViewController(
                identifier: RouteString.FixturesPage)
            as! FixturesCollectionViewController
                fixturesVC.sportType = sportType
                fixturesVC.league = league
        from.navigationController?.pushViewController(fixturesVC, animated: true)
        
    }
    
}

class RouteString {
    static let HomePage = "main"
    static let CountriesPage = "countries"
    static let LeaguesPage = "leagues"
    static let FixturesPage = "fixtures"
    static let EventDetailsPage = "eventDetails"
}
