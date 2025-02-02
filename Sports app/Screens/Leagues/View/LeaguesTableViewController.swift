//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

class LeaguesTableViewController: UITableViewController, LeagueProtocol {

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
        setupNetworkProvider()
        setupSearchController()
        self.navigationItem.title = sportType.rawValue
        presenter.attachView(view: self)
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Leagues"

        let gradientView = UIView(frame: self.view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = ThemeManager.gradientColors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        tableView.backgroundView = gradientView
    }

    func setupNetworkProvider() {
        if NetworkManager.instance.isConnectedToNetwork {
            self.presenter.getDataFromAPI(
                sportType: sportType, countryId: countryId)
        } else {
            self.showNetworkErrorAlert()
        }
        NetworkManager.instance.onNetworkRecovered = {
            print("recovered")
        }
        NetworkManager.instance.onNetworkLost = {
            self.showNetworkErrorAlert()
        }
    }

    func renderToView(result: LeagueResult?) {
        DispatchQueue.main.async {
            if result?.success == 1 {
                self.leagues = result?.result ?? []
                self.filteredLeagues = self.leagues
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
                handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create the action
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { action, view, completionHandler in
            // Handle adding to favorites
            self.addToFavorites(at: indexPath)
            completionHandler(true)
        }
        
        // Customize the action (e.g., change background color)
        favoriteAction.backgroundColor = .systemCyan
        favoriteAction.image = UIImage(systemName: "star.fill")
        
        // Return the swipe configuration with the action
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

    // Example function to handle adding to favorites
    func addToFavorites(at indexPath: IndexPath) {
        var item = filteredLeagues[indexPath.row] // Replace `data` with your actual data source
        item.sportType = sportType.rawValue
        let result = DBManager.shared.addLeagueToLocalDB(league: item)
        if result?.success ?? false {
            print(result?.message ?? "okkaay")
        }
        // Update your data model and UI accordingly
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            return
        }

        isSearchActive = true
        filteredLeagues = leagues.filter {
            $0.leagueName!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    // Handle cancel button press (optional)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredLeagues = leagues
        tableView.reloadData()
    }
}
