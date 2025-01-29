//
//  Presenter.swift
//  MVPMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation
class HomePresenter{
    var view : HomeProtocol!
    func attachView(view: HomeProtocol) {
        self.view = view
    }
    func getDataFromAPI(){
        Services.fetchCountriesFromAPI{res in
            self.view.renderToView(result: res!)
        }
    }
    func getData(){
        Services.fetchCountriesFromAPI{res in
            self.view.renderToView(result: res!)
        }
    }
}
