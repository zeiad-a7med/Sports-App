//
//  Presenter.swift
//  MVPMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation
class LeaguePresenter{
    var view : LeagueProtocol!
    func attachView(view: LeagueProtocol) {
        self.view = view
    }
    func getDataFromAPI(sportType : SportType , countryId: Int?){
        LeagueServices.fetchLeaguesFromAPI(sportType: sportType ,countryId: countryId){res in
            self.view.renderToView(result: res)
        }
    }
}
