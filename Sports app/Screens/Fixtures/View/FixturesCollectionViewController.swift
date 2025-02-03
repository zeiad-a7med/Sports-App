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
    FixturesProtocol,
    DataStateProtocol
{
    var upCommingEvents: [Event] = []
    var latestEvents: [Event] = []
    var teams: [Team] = []
    let presenter = FixturesPresenter()
    var sportType: SportType!
    var league: League!
    var lastSection = 0
    let sectionTitles = ["Upcoming Events", "Latest Events", "Upcoming Events"]
    var networkIndicator: UIActivityIndicatorView!
    var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sportType.rawValue
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        let layout = UICollectionViewCompositionalLayout { index, enviroment in
            return self.drawSection(index: index)
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
        setupNetworkProvider()
        presenter.attachView(view: self)
        isFavorite = UserDefaults.standard.bool(forKey: "\(league.leaguekey!)")
        updateFavoriteButton()
        let longPressGesture = UILongPressGestureRecognizer(
            target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = league.leagueName
        navigationController?.setNavigationBarHidden(false, animated: true)
        ThemeManager.addMainBackgroundToCollectionView(at: self)
    }
    // MARK: - Data providers section

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
        self.teams = []
        self.latestEvents = []
        self.upCommingEvents = []
        self.collectionView.reloadData()
        ThemeManager.emptyState(
            at: self, message: "The internet connection appears to be offline",
            emptyStateType: .noInternetConnection)
        self.networkIndicator.stopAnimating()
        if let floatingBtn = self.view.viewWithTag(111),
            let index = self.view.subviews.firstIndex(of: floatingBtn)
        {
            self.view.subviews[index].removeFromSuperview()
        }
        self.showNetworkErrorAlert()
    }
    func networkRecoveredAction() {
        ThemeManager.removeEmptyState(from: self)
        networkIndicator.startAnimating()
        self.presenter.getDataFromAPI(sportType: sportType, league: league)
        self.presenter.getTeamsDataFromAPI(
            sportType: sportType, league: league)

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
                self.setLastSectionNumber()
                self.checkDataState()
                if !self.latestEvents.isEmpty && self.latestEvents.count > 10 {
                    self.buildFloatingButton()
                }

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
                self.setLastSectionNumber()
                self.checkDataState()
            }
        }
    }
    func checkDataState() {
        if !self.teams.isEmpty || !self.upCommingEvents.isEmpty
            || !self.latestEvents.isEmpty
        {
            ThemeManager.removeEmptyState(from: self)
        }
        if self.teams.isEmpty && self.upCommingEvents.isEmpty
            && self.latestEvents.isEmpty
        {
            ThemeManager.emptyState(
                at: self,
                message: "No matches available for \(self.league.leagueName!)",
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

    // MARK: - supporting components section
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                showOptions(for: indexPath)
            }
        }
    }
    func buildFloatingButton() {
        let scrollButton = UIButton(type: .system)
        scrollButton.tag = 111
        scrollButton.setImage(
            UIImage(systemName: "arrow.down")?.withRenderingMode(
                .alwaysTemplate), for: .normal)
        scrollButton.tintColor = .white  // Ensure the arrow is visible
        scrollButton.translatesAutoresizingMaskIntoConstraints = false
        scrollButton.layer.cornerRadius = 25
        scrollButton.backgroundColor = UIColor(red: 24/255, green: 184/255, blue: 154/255, alpha: 1)
        scrollButton.addTarget(
            self, action: #selector(scrollToLastSection), for: .touchUpInside)
        view.addSubview(scrollButton)
        NSLayoutConstraint.activate([
            scrollButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollButton.widthAnchor.constraint(equalToConstant: 50),
            scrollButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    @objc func scrollToLastSection() {
        var section = 0
        var row = 0
        if teams.count > 0 {
            section = 2
        } else {
            section = 1
            row = latestEvents.count - 1
        }
        collectionView.scrollToItem(
            at: IndexPath(row: row, section: section), at: .bottom, animated: true
        )
    }
    @objc func favoriteTapped() {
        isFavorite.toggle()
        UserDefaults.standard.set(isFavorite, forKey: "\(league.leaguekey!)")
        if isFavorite {
            league.sportType = sportType.rawValue
            let result = DBManager.shared.addLeagueToLocalDB(league: league)
            showAlert(message: result?.message ?? "", title: "")
        } else {
            let result = DBManager.shared.removeLeagueFromLocalDB(
                leagueKey: league.leaguekey!)
            showAlert(message: result?.message ?? "", title: "")
        }
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
    func showAlert(message: String, title: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Ok", style: .default,
                handler: nil))
        self.present(alert, animated: true)
    }
    func showOptions(for indexPath: IndexPath) {

        var event: Event?
        if indexPath.section == 0 {
            event = upCommingEvents[indexPath.row]
        } else {
            return
        }

        let date = (event?.eventDate ?? "") + "\n" + (event?.eventTime ?? "")
        var eventName: String?

        if event?.eventHomeTeam != nil && event?.eventAwayTeam != nil {
            eventName = (event?.eventHomeTeam ?? "").appending(" VS ")
                .appending(event?.eventAwayTeam ?? "")
        } else {
            eventName = (event?.eventFirstPlayer ?? "").appending(" VS ")
                .appending(event?.eventSecondPlayer ?? "")
        }
        let alert = UIAlertController(
            title: eventName,
            message: "set reminder for this event at \n \(date)",
            preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(
                title: "set reminder", style: .default,
                handler: { _ in
                    print("Delete item at \(indexPath)")
                }))

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let vc = collectionView.window?.rootViewController {
            vc.present(alert, animated: true)
        }
    }

    // MARK: - UICollectionViewDataSource section
    func setLastSectionNumber() {
        var numberOfSections: Int = 0
        if !upCommingEvents.isEmpty {
            numberOfSections += 1
        }
        if !latestEvents.isEmpty {
            numberOfSections += 1
        }
        if !teams.isEmpty {
            numberOfSections += 1
        }
        lastSection = numberOfSections - 1
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
        if !upCommingEvents.isEmpty {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40))
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
        if !teams.isEmpty {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40))
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
        if !latestEvents.isEmpty {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        return section

    }
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
        cell.awayTeamName.text = event.eventAwayTeam ?? event.eventFirstPlayer
        cell.homeTeamName.text = event.eventHomeTeam ?? event.eventSecondPlayer

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
    override func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 2 {
            let team = teams[indexPath.row]
            Router.goToTeamPage(from: self, team: team)
        }
    }

}
