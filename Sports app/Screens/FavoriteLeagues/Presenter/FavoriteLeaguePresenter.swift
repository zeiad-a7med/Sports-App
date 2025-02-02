//
//  Presenter.swift
//  MVPMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation
class FavoriteLeaguePresenter{
    var view : FavoriteLeagueProtocol!
    func attachView(view: FavoriteLeagueProtocol) {
        self.view = view
    }
    func getDataFromLocalDB(){
        FovoriteLeagueLocalServices.fetchLeaguesFromLocalDB{res in
            self.view.renderToView(result: res)
        }
    }
}
