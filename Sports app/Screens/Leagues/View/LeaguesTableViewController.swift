//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

class LeaguesTableViewController: UITableViewController, LeagueProtocol,
    DataStateProtocol
{

    var leagues: [League] = []
    let presenter = LeaguePresenter()
    var sportType: SportType!
    var countryId: Int?
    var networkIndicator: UIActivityIndicatorView!
    var filteredLeagues: [League] = []
    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        self.tableView.register(
            nib, forCellReuseIdentifier: "LeagueTableViewCell")
        self.navigationItem.title = sportType.rawValue
        presenter.attachView(view: self)
        setupNetworkProvider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Leagues"
        ThemeManager.addMainBackgroundToTable(at: self)
    }

    func setupNetworkProvider() {
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        if NetworkManager.instance.isConnectedToNetwork {
            self.networkRecoveredAction()
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
        self.filteredLeagues = []
        self.tableView.reloadData()
        ThemeManager.emptyState(at: self, message: "The internet connection appears to be offline", emptyStateType: .noInternetConnection)
        self.networkIndicator.stopAnimating()
        self.showNetworkErrorAlert()
    }
    func networkRecoveredAction() {
        ThemeManager.removeEmptyState(from: self)
        self.networkIndicator.startAnimating()
        self.presenter.getDataFromAPI(
            sportType: sportType, countryId: countryId)
    }
    

    func renderToView(result: LeagueResult?) {
        DispatchQueue.main.async {
            if result?.success == 1 {
                self.leagues = result?.result ?? []
                self.filteredLeagues = self.leagues
                self.tableView.reloadData()
                self.setupSearchController()
            } else {
                self.showNetworkErrorAlert()
            }
            self.networkIndicator.stopAnimating()
        }
    }

    func checkDataState() {
        if !self.leagues.isEmpty {
            ThemeManager.removeEmptyState(from: self)
        }
        if self.leagues.isEmpty {
            ThemeManager.emptyState(
                at: self, message: "No matches available for this country",
                emptyStateType: .emptyData)
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
        return filteredLeagues.count
    }

    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "LeagueTableViewCell", for: indexPath)
            as! LeagueTableViewCell

        let league = filteredLeagues[indexPath.row]
        cell.leaguelabel.text = league.leagueName
        if league.leagueLogo != nil {
            if let imageUrl = URL(string: league.leagueLogo!) {
                cell.leagueImage.kf.setImage(with: imageUrl)
            } else {
                cell.leagueImage.image = UIImage(named: sportType.rawValue)
            }
        } else {
            cell.leagueImage.image = UIImage(named: sportType.rawValue)
        }

        return cell
    }
    override func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 120
    }
    override func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        Router.goToFixturesPage(
            from: self, sportType: sportType,
            league: filteredLeagues[indexPath.row])
    }

}
extension LeaguesTableViewController: UISearchResultsUpdating,
    UISearchBarDelegate
{

    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for league"

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
            filteredLeagues = leagues
            tableView.reloadData()
            ThemeManager.removeEmptyState(from: self)
            return
        }

        isSearchActive = true
        filteredLeagues = leagues.filter {
            $0.leagueName!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()

        if filteredLeagues.isEmpty {
            ThemeManager.emptyState(
                at: self, message: "No Leagues found",
                emptyStateType: .emptySearch)
        } else {
            ThemeManager.removeEmptyState(from: self)
        }
    }

    // Handle cancel button press (optional)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredLeagues = leagues
        tableView.reloadData()
        ThemeManager.removeEmptyState(from: self)
    }
}
