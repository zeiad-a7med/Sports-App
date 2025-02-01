//
//  DBManager.swift
//  ScrollView
//
//  Created by Zeiad on 12/01/2025.
//

import CoreData
import Foundation
import UIKit

class DBManager {
    static let shared = DBManager()
    var manager: NSManagedObjectContext?
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = appDelegate.persistentContainer.viewContext
    }

    func addLeagueToLocalDB(league: League) -> LocalDBResponse? {
//        let fetch = NSFetchRequest<NSManagedObject>(entityName: "League")
        //        do {
        //            let moviesDBList: [NSManagedObject] = try manager!.fetch(fetch)
        //            for movieDB in moviesDBList {
        //                manager?.delete(movieDB)
        //            }
        //            print("all deleted !!")
        //        } catch let error {
        //            print(error.localizedDescription)
        //        }
        let entity = NSEntityDescription.entity(
            forEntityName: "LeagueModel", in: manager!)
        let LeagueDB = NSManagedObject(entity: entity!, insertInto: manager)
        LeagueDB.setValue(league.leaguekey, forKey: "leaguekey")
        LeagueDB.setValue(league.leagueName, forKey: "leagueName")
        LeagueDB.setValue(league.leagueLogo, forKey: "leagueLogo")
        LeagueDB.setValue(league.leagueYear, forKey: "leagueYear")
        LeagueDB.setValue(league.countrykey, forKey: "countrykey")
        LeagueDB.setValue(league.countryName, forKey: "countryName")
        LeagueDB.setValue(league.countryLogo, forKey: "countryLogo")
        do {
            try manager!.save()
            return LocalDBResponse(
                success: true,
                message: "League added to favorites successfully", data: nil)

        } catch _ {
            return LocalDBResponse(
                success: false, message: "Failed to add League to favorites",
                data: nil)

        }
    }
    
    func getFavoriteLeaguesFromLocalDB() -> LocalDBResponse {
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "LeagueModel")
        do {
            let leagueDBList: [NSManagedObject] = try manager!.fetch(fetch)
            var leagueList: [League] = []
            for leagueDB in leagueDBList {
                leagueList.append(
                    League.leagueFromNSManagedObject(object: leagueDB))
            }
            return LocalDBResponse(success: true , message: "success" , data: leagueList)
        } catch _ {
            return LocalDBResponse(success: false , message: "failed to load data" , data: nil)
        }
    }
}

class LocalDBResponse {
    var success: Bool
    var message: String?
    var data: [Any]?
    init(success: Bool, message: String? = nil, data: [Any]? = nil) {
        self.success = success
        self.message = message
        self.data = data
    }
}
