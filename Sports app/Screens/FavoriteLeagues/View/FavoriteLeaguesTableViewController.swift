//
//  CountriesTableViewController.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

class FavoriteLeaguesViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource, FavoriteLeagueProtocol
{

    @IBOutlet weak var tableView: UITableView!
    var leagues: [League] = []
    let presenter = FavoriteLeaguePresenter()
    let searchController = UISearchController(searchResultsController: nil)

    var filteredLeagues: [League] = []
    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        self.tableView.register(
            nib, forCellReuseIdentifier: "LeagueTableViewCell")
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = ThemeManager.gradientColors
        view.layer.insertSublayer(layer, at: 0)
        presenter.attachView(view: self)
        //        setupSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter.getDataFromLocalDB()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func renderToView(result: LocalDBResponse?) {
        if (result?.success) != nil {
            DispatchQueue.main.async {
                self.leagues = result?.data ?? []
                self.filteredLeagues = result?.data ?? []
                if(!self.leagues.isEmpty){
//                    self.view.layer.sublayers.
                    self.tableView.reloadData()
                }else{
                    ThemeManager.emptyState(at: self)
                }
                
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return filteredLeagues.count
    }

    func tableView(
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
                cell.leagueImage.image = UIImage(
                    named: league.sportType ?? SportType.football.rawValue)
            }
        } else {
            cell.leagueImage.image = UIImage(
                named: league.sportType ?? SportType.football.rawValue)
        }

        return cell
    }
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 120
    }
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        Router.goToFixturesPage(
            from: self,
            sportType: SportType.allCases.first {
                $0.rawValue == filteredLeagues[indexPath.row].sportType
            } ?? .football,
            league: filteredLeagues[indexPath.row])
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               removeFromFavorites(at: indexPath)
           }
       }
    
    func removeFromFavorites(at indexPath: IndexPath) {
        let item = filteredLeagues[indexPath.row]  // Replace `data` with your actual
        let result = DBManager.shared.removeLeagueFromLocalDB(leagueKey: item.leaguekey!)
        if (result != nil && result?.success == true) {
            filteredLeagues.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }

}
extension FavoriteLeaguesViewController: UISearchResultsUpdating,
    UISearchBarDelegate
{

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in your favorites"
        //        searchController.searchBar.backgroundColor = .clear
        //        searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.showsCancelButton = false
        self.tableView.tableHeaderView = searchController.searchBar
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
