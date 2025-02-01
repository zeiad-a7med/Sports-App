//
//  Presenter.swift
//  MVPMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation
class FixturesPresenter{
    var view : FixturesProtocol!
    func attachView(view: FixturesProtocol) {
        self.view = view
    }
    func getDataFromAPI(sportType : SportType , league: League){
        FixturesServices.fetchFixturesFromAPI(sportType: sportType ,league: league){res in
            self.view.renderToView(result: res)
        }
    }
    
    func getTeamsDataFromAPI(sportType : SportType , league: League){
        FixturesServices.fetchTeamsFromAPI(sportType: sportType ,league: league){res in
            self.view.renderTeamsToView(result: res)
        }
    }
}
