//
//  Sports_appTests.swift
//  Sports appTests
//
//  Created by Zeiad on 28/01/2025.
//

import XCTest

@testable import Sports_app

final class Services_appTests: XCTestCase {
    var league : League!
    override func setUpWithError() throws {
        league = League()
        league.leaguekey = 31
        league.countrykey = 10
        league.sportType = SportType.football.rawValue
        
        NetworkManager.resetInstance()
    }
    override func tearDownWithError() throws {
        
    }

    func testFetchCountriesFromAPIWithNetworkCheck() throws {
        let myExpectation = expectation(description: "waitUntilFinish")
        NetworkManager.instance.onNetworkRecovered = {
            CountryServices.fetchCountriesFromAPI(sportType: .football) { response in
                if response?.success == 0 {
                    XCTAssertNil(response?.result)
                    myExpectation.fulfill()
                } else {
                    XCTAssertEqual(response?.result?.isEmpty,false)
                    myExpectation.fulfill()
                }
            }
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,true)
        }
        NetworkManager.instance.onNetworkLost = {
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,false)
            myExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
    func testFetchLeaguesFromAPIWithNetworkCheck() throws {
        let myExpectation = expectation(description: "waitUntilFinish")
        NetworkManager.instance.onNetworkRecovered = {
            LeagueServices.fetchLeaguesFromAPI(sportType: .football, countryId: self.league.countrykey){ response in
                if response?.success == 0 {
                    XCTAssertNil(response?.result)
                    myExpectation.fulfill()
                } else {
                    XCTAssertEqual(response?.result?.isEmpty,false)
                    myExpectation.fulfill()
                }
            }
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,true)
        }
        NetworkManager.instance.onNetworkLost = {
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,false)
            myExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 15)
    }
    func testFetchFixturesFromAPIWithNetworkCheck() throws {
        let myExpectation = expectation(description: "waitUntilFinish")
        NetworkManager.instance.onNetworkRecovered = {
            FixturesServices.fetchFixturesFromAPI(sportType: .football, league: self.league){ response in
                if response?.success == 0 {
                    XCTAssertNil(response?.result)
                    myExpectation.fulfill()
                } else {
                    XCTAssertEqual(response?.result?.isEmpty,false)
                    myExpectation.fulfill()
                }
            }
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,true)
        }
        NetworkManager.instance.onNetworkLost = {
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,false)
            myExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 15)
    }
    func testFetchTeamDataFromAPIWithNetworkCheck() throws {
        let myExpectation = expectation(description: "waitUntilFinish")
        NetworkManager.instance.onNetworkRecovered = {
            FixturesServices.fetchTeamsFromAPI(sportType:.football , league: self.league){ response in
                if response?.success == 0 {
                    XCTAssertNil(response?.result)
                    myExpectation.fulfill()
                } else {
                    XCTAssertEqual(response?.result?.isEmpty,false)
                    myExpectation.fulfill()
                }
            }
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,true)
        }
        NetworkManager.instance.onNetworkLost = {
            XCTAssertEqual(NetworkManager.instance.isConnectedToNetwork,false)
            myExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 15)
    }
    func testFetchFavoritesFromCoreDB() throws {
        FovoriteLeagueLocalServices.fetchLeaguesFromLocalDB{ response in
            if response.success{
                XCTAssertEqual(response.data?.isEmpty,false)
            }
        }
    }
}
