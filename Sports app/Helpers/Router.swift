//
//  Router.swift
//  MVVMtest
//
//  Created by Zeiad on 27/01/2025.
//
import UIKit
class Router{
    
    static func goToHomePage(from : UIViewController){
        let homeVC = from.storyboard?.instantiateViewController(identifier: RouteString.HomePage) as! HomeViewController
        from.navigationController?.pushViewController(homeVC, animated: true)
    }
    static func goToCountriesPage(from : UIViewController , sportName : String){
        let countriesVC = from.storyboard?.instantiateViewController(identifier: RouteString.CountriesPage) as! CountriesTableViewController
        countriesVC.sportName = sportName
        from.navigationController?.pushViewController(countriesVC, animated: true)
    }
}


class RouteString{
    static let HomePage = "home"
    static let CountriesPage = "countries"
}
