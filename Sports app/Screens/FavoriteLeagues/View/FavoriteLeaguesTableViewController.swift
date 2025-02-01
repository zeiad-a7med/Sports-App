//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

class FavoriteLeaguesTableViewController: UITableViewController{

    var leagues: [League] = []
    let presenter = LeaguePresenter()
    var filteredLeagues: [League] = []
    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        self.tableView.register(
            nib, forCellReuseIdentifier: "LeagueTableViewCell")
        let gradientView = UIView(frame: self.view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = ThemeManager.gradientColors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = gradientView
        setupSearchController()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
//        self.navigationItem.title = "Favorite Leagues"
        
    }

    func loadData() {
        let response = DBManager.shared.getFavoriteLeaguesFromLocalDB()
        if response.success{
            DispatchQueue.main.async {
                self.filteredLeagues = response.data as? [League] ?? []
                self.tableView.reloadData()
            }
            
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
                cell.leagueImage.image = UIImage(named: league.sportType ?? SportType.football.rawValue)
            }
        } else {
            cell.leagueImage.image = UIImage(named: league.sportType ?? SportType.football.rawValue)
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
            from: self, sportType:  SportType.allCases.first{$0.rawValue == filteredLeagues[indexPath.row].sportType} ?? .football,
            league: filteredLeagues[indexPath.row])
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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
extension FavoriteLeaguesTableViewController: UISearchResultsUpdating,
    UISearchBarDelegate
{

    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search for league"

            // Use navigationItem instead
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
