//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

class CountriesTableViewController: UITableViewController, CountryProtocol {

    var countries: [Country] = []
    var sportName: String!
    var networkIndicator: UIActivityIndicatorView!
    var filteredcountries: [Country] = []
    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sportName
        setupNetworkProvider()
        setupSearchController()
        let presenter = CountryPresenter()
        presenter.attachView(view: self)
        
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
        presenter.getDataFromAPI(sportName: sportName)
        

    }
    
    func setupNetworkProvider(){
        NetworkManager.instance.onNetworkRecovered = {
            print("recovered")
        }
        NetworkManager.instance.onNetworkLost = {
            print("Lost")
        }
    }
    
    
    func renderToView(result: CountryResult) {
        DispatchQueue.main.async {
            self.countries = result.result ?? []
            self.filteredcountries = self.countries
            self.tableView.reloadData()
            self.networkIndicator.stopAnimating()

        }
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)

        cell.textLabel?.text = filteredcountries[indexPath.row].countryName ?? ""
        return cell
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
extension CountriesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Country"

        // Attach the search bar to the navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Update search results
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearchActive = false
            filteredcountries = countries
            tableView.reloadData()
            return
        }

        isSearchActive = true
        filteredcountries = countries.filter { $0.countryName!.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }

    // Handle cancel button press (optional)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredcountries = countries
        tableView.reloadData()
    }
}
