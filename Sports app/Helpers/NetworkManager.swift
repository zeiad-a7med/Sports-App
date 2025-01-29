//
//  NetworkManager.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import Foundation
import Reachability

protocol NetworkManagerProtocol {
    var isConnectedToNetwork: Bool { get }
}

class NetworkManager {
    var reachability : Reachability!
    static let instance = NetworkManager()
    var onNetworkRecovered : (()->()) = {}
    var onNetworkLost : (()->()) = {}
    var isConnectedToNetwork : Bool?{
        didSet {
            isConnectedToNetwork == true ?
            onNetworkRecovered() :
            onNetworkLost()
        }
    }
    private init() {
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability instance")
        }
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.isConnectedToNetwork = true
            }
        }
        
        self.reachability.whenUnreachable = { _ in
            self.isConnectedToNetwork = false
        }
        
        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}
