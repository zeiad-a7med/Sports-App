//
//  FixturesCollectionViewController.swift
//  Sports app
//
//  Created by Zeiad on 01/02/2025.
//

import Kingfisher
import UIKit

class FixturesCollectionViewController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout,
    FixturesProtocol
{

    var upCommingEvents: [Event] = []
    var latestEvents: [Event] = []
    var teams: [Team] = []
    let presenter = FixturesPresenter()
    var sportType: SportType!
    var league: League!
    let sectionTitles = ["Upcoming Events", "Latest Events", "Upcoming Events"]
    var networkIndicator: UIActivityIndicatorView!
    var isFavorite = false
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        let layout = UICollectionViewCompositionalLayout { index, enviroment in
            return self.drawSection(index: index)
        }
        collectionView.setCollectionViewLayout(layout, animated: true)

        setupNetworkProvider()
        self.navigationItem.title = sportType.rawValue
        presenter.attachView(view: self)
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
        isFavorite = UserDefaults.standard.bool(forKey: "\(league.leaguekey!)")
        updateFavoriteButton()

    }
    func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
    }


    @objc func favoriteTapped() {
        isFavorite.toggle()
        UserDefaults.standard.set(isFavorite, forKey: "\(league.leaguekey!)")
        updateFavoriteButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = league.leagueName

        let gradientView = UIView(frame: self.view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = ThemeManager.gradientColors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        self.collectionView.backgroundView = gradientView
    }

    func setupNetworkProvider() {
        if NetworkManager.instance.isConnectedToNetwork {
            self.presenter.getDataFromAPI(sportType: sportType, league: league)
            self.presenter.getTeamsDataFromAPI(
                sportType: sportType, league: league)
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

    func renderToView(result: FixturesResult?) {
        DispatchQueue.main.async {
            if result?.success == 1 {
                self.upCommingEvents =
                    result?.result?.filter {
                        $0.getStatus() == .live || $0.getStatus() == .notStarted
                    } ?? []
                self.latestEvents =
                    result?.result?.filter { $0.getStatus() == .finished } ?? []

                self.collectionView.reloadData()

            } else {
                self.showNetworkErrorAlert()
            }
            self.networkIndicator.stopAnimating()

        }
    }
    func renderTeamsToView(result: TeamsResult?) {
        DispatchQueue.main.async {
            if result?.success == 1 {
                self.teams = result?.result ?? []
                self.collectionView.reloadData()
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

    func drawSection(index: Int) -> NSCollectionLayoutSection {

        switch index {
        case 0:
            return drawUpcommingEvents()
        case 2:
            return drawEventsTeams()
        default:
            return drawLatestEvents()
        }
    }

    func drawUpcommingEvents() -> NSCollectionLayoutSection {
        let nib = UINib(nibName: "FootballEventCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "FootballEventCollectionViewCell")
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .absolute(220))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 32)

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 5, bottom: 16, trailing: 0)
        if(!upCommingEvents.isEmpty){
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        
        return section

    }

    func drawEventsTeams() -> NSCollectionLayoutSection {
        let nib = UINib(nibName: "TeamCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "TeamCollectionViewCell")
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(0.95))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(220),
            heightDimension: .absolute(220))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5, leading: 0, bottom: 5, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 20, bottom: 10, trailing: 20)
        if(!teams.isEmpty){
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        return section

    }

    func drawLatestEvents() -> NSCollectionLayoutSection {
        let nib = UINib(nibName: "FootballEventCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "FootballEventCollectionViewCell")
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(220))

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5, leading: 0, bottom: 5, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 20, bottom: 10, trailing: 20)
        if(!latestEvents.isEmpty){
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        return section

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return upCommingEvents.count
        case 1:
            return latestEvents.count
        case 2:
            return teams.count
        default:
            return 0
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        switch indexPath.section {
        case 0:
            cell = buildEventCell(indexPath: indexPath)
        case 1:
            cell = buildEventCell(indexPath: indexPath)
        case 2:
            cell = buildTeamCell(indexPath: indexPath)
        default:
            cell = buildEventCell(indexPath: indexPath)
        }

        return cell!
    }

    func buildEventCell(indexPath: IndexPath) -> FootballEventCollectionViewCell
    {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "FootballEventCollectionViewCell",
                for: indexPath)
            as! FootballEventCollectionViewCell
        var event: Event
        switch indexPath.section {
        case 0:
            event = upCommingEvents[indexPath.row]
        case 1:
            event = latestEvents[indexPath.row]
        default:
            event = upCommingEvents[indexPath.row]
        }

        if event.homeTeamLogo != nil {
            if let imageUrl = URL(string: event.homeTeamLogo!) {
                cell.homeTeamLogo.kf.setImage(with: imageUrl)
            } else {
                cell.homeTeamLogo.image = UIImage(named: sportType.rawValue)
            }
        } else {
            cell.homeTeamLogo.image = UIImage(named: sportType.rawValue)
        }

        if event.awayTeamLogo != nil {
            if let imageUrl = URL(string: event.awayTeamLogo!) {
                cell.awayTeamLogo.kf.setImage(with: imageUrl)
            } else {
                cell.awayTeamLogo.image = UIImage(named: sportType.rawValue)
            }
        } else {
            cell.awayTeamLogo.image = UIImage(named: sportType.rawValue)
        }
        cell.awayTeamName.text = event.eventAwayTeam
        cell.homeTeamName.text = event.eventHomeTeam

        cell.matchStatusView.layer.backgroundColor =
            ThemeManager.getEventStatusColor(status: event.getStatus())
        cell.matchStatusLabel.text = event.getStatus().rawValue

        cell.eventResult.text =
            event.eventFinalResult != "-" ? event.eventFinalResult : ""
        cell.eventDateAndTime.text =
            "\(event.eventDate ?? event.leagueSeason ?? "")\n\(event.eventTime!)"

        return cell

    }
    func buildTeamCell(indexPath: IndexPath) -> TeamCollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "TeamCollectionViewCell", for: indexPath)
            as! TeamCollectionViewCell
        let team = teams[indexPath.row]

        if team.teamLogo != nil {
            if let imageUrl = URL(string: team.teamLogo!) {
                cell.teamLogo.kf.setImage(with: imageUrl)
            } else {
                cell.teamLogo.image = UIImage(named: sportType.rawValue)
            }
        } else {
            cell.teamLogo.image = UIImage(named: sportType.rawValue)
        }
        cell.teamName.text = team.teamName
        return cell

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)  // Adjust height as needed
    }
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
            as! HeaderView
        var title: String = ""
        switch indexPath.section {
        case 0:
            title = upCommingEvents.isEmpty ? "" : "Upcomming"
        case 1:
            title = latestEvents.isEmpty ? "" : "Latest"
        case 2:
            title = teams.isEmpty ? "" : "Teams"
        default:
            break
        }
        header.titleLabel.text = title
        return header
    }

    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: collectionView.frame.width, height: 50)
    //    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

    }
    */

}

class HeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
