//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit
import Kingfisher
class CountriesTableViewController: UITableViewController, CountryProtocol {

    var countries: [Country] = []
    let presenter = CountryPresenter()
    var sportType: SportType!
    var networkIndicator: UIActivityIndicatorView!
    var filteredcountries: [Country] = []
    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CountryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CountryTableViewCell")
        presenter.attachView(view: self)
        setupNetworkProvider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = sportType.rawValue.capitalized
        ThemeManager.addMainBackgroundToTable(at: self)
    }
    
    
    func setupNetworkProvider() {
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        
        if NetworkManager.instance.isConnectedToNetwork {
            networkRecoveredAction()
        } else {
            self.networkLostAction()
        }
        NetworkManager.instance.onNetworkRecovered = {
            self.networkRecoveredAction()
        }
        NetworkManager.instance.onNetworkLost = {
            self.networkLostAction()
        }
    }

    func networkLostAction() {
        self.filteredcountries = []
        self.tableView.reloadData()
        ThemeManager.emptyState(at: self, message: "The internet connection appears to be offline", emptyStateType: .noInternetConnection)
        self.networkIndicator.stopAnimating()
        self.showNetworkErrorAlert()
    }
    func networkRecoveredAction() {
        ThemeManager.removeEmptyState(from: self)
        self.networkIndicator.startAnimating()
        self.presenter.getDataFromAPI(sportType: self.sportType)
    }
    
    func renderToView(result: CountryResult?) {
        DispatchQueue.main.async {
            if result?.success == 1 {
                self.countries = result?.result ?? []
                self.filteredcountries = self.countries
                self.setupSearchController()
                self.tableView.reloadData()
            } else {
                self.showNetworkErrorAlert()
            }
            self.networkIndicator.stopAnimating()
        }
    }

    func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "Something went wrong",
            message: "Please check your internet connection",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Ok", style: .default,
                handler: nil))
        self.present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredcountries.count
    }

    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        cell.countrylabel.text = filteredcountries[indexPath.row].countryName
        
        let countryLogo = filteredcountries[indexPath.row].countryLogo
        if(countryLogo != nil){
            if let imageUrl = URL(string: countryLogo!) {
                cell.countryImage.kf.setImage(with: imageUrl)
            } else {
                cell.countryImage.image = UIImage(named: sportType.rawValue)
            }
        }else{
            cell.countryImage.image = UIImage(named: sportType.rawValue)
        }
        
        return cell
    }
    override func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        Router.goToLeaguesPage(
            from: self, sportType: sportType,
            countryId: filteredcountries[indexPath.row].countrykey!)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
extension CountriesTableViewController: UISearchResultsUpdating,
    UISearchBarDelegate
{

    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        if(sportType == .tennis){
            searchController.searchBar.placeholder = "Search for Tournaments Types"
        }else{
            searchController.searchBar.placeholder = "Search for Country"
        }
        

        // Attach the search bar to the navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Update search results
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            !searchText.isEmpty
        else {
            isSearchActive = false
            filteredcountries = countries
            tableView.reloadData()
            ThemeManager.removeEmptyState(from: self)
            return
        }

        isSearchActive = true
        filteredcountries = countries.filter {
            $0.countryName!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
        if(filteredcountries.isEmpty){
            ThemeManager.emptyState(at: self, message: "No countries found", emptyStateType: .emptySearch)
        }else{
            ThemeManager.removeEmptyState(from: self)
        }
    }

    // Handle cancel button press (optional)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredcountries = countries
        tableView.reloadData()
        ThemeManager.removeEmptyState(from: self)
    }
}
