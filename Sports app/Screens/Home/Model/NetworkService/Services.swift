//
//  Service.swift
//  MVCMode
//
//  Created by Zeiad on 23/01/2025.
//

import Foundation




class Services : HomeNetworkProtocol {
    static func fetchCountriesFromAPI(completionHandler : @escaping(HomeResult?) -> Void){
        let url = URL(string: EndPoints.football.appending(EndPointKey.met).appending("Countries"))
        guard let newUrl = url else { return }
        let request = URLRequest(url: newUrl)
        
        let seesion = URLSession(configuration: .default)
        let task = seesion.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do{
                let result =  try JSONDecoder().decode(HomeResult.self, from: data)
                completionHandler(result)
            }catch{
                print(error.localizedDescription)
                completionHandler(nil)
            }
            
        }
        task.resume()
    }
}
