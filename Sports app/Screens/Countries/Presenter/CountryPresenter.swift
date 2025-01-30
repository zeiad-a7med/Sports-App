//
//  Presenter.swift
//  MVPMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation
class CountryPresenter{
    var view : CountryProtocol!
    func attachView(view: CountryProtocol) {
        self.view = view
    }
    func getDataFromAPI(sportType : SportType){
        CountryServices.fetchCountriesFromAPI(sportType: sportType){res in
            self.view.renderToView(result: res)
        }
    }
}
