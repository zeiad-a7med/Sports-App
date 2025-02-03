//
//  TeamDetailsCollectionViewController.swift
//  Sports app
//
//  Created by Zeiad on 02/02/2025.
//

import Kingfisher
import UIKit

class TeamDetailsCollectionViewController: UICollectionViewController,
    UICollectionViewDelegateFlowLayout
{

    var team: Team?
    var sportype: SportType?
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
        self.navigationItem.title = team?.teamName
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = team?.teamName
        navigationController?.setNavigationBarHidden(false, animated: true)
        ThemeManager.addMainBackgroundToCollectionView(at: self)
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
            return drawTeamHeaderSection()
        case 1:
            return drawCouchesSection()
        case 2:
            return drawPlayersSection()
        default:
            return drawPlayersSection()
        }
    }

    func drawTeamHeaderSection() -> NSCollectionLayoutSection {

        let nib = UINib(nibName: "TeamCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "TeamCollectionViewCell")

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(220),
            heightDimension: .absolute(220))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])

        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 5, bottom: 16, trailing: 5)
        return section

    }
    func drawCouchesSection() -> NSCollectionLayoutSection {

        let nib = UINib(nibName: "TeamCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "TeamCollectionViewCell")
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(220),
            heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 5, bottom: 16, trailing: 5)
        if (team?.coaches?.isEmpty) != nil {
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
    func drawPlayersSection() -> NSCollectionLayoutSection {
        let nib = UINib(nibName: "PlayerCardCollectionViewCell", bundle: nil)
        self.collectionView.register(
            nib, forCellWithReuseIdentifier: "PlayerCardCollectionViewCell")
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
        if (team?.players?.isEmpty) != nil {
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
            return 1
        case 1:
            return team?.coaches?.count ?? 0
        case 2:
            return team?.players?.count ?? 0
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
            cell = buildTeamHeaderCell(indexPath: indexPath)
        case 1:
            cell = buildCoacheCell(indexPath: indexPath)
        case 2:
            cell = buildPlayerCell(indexPath: indexPath)
        default:
            cell = buildPlayerCell(indexPath: indexPath)
        }

        return cell!
    }
    func buildTeamHeaderCell(indexPath: IndexPath) -> TeamCollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "TeamCollectionViewCell", for: indexPath)
            as! TeamCollectionViewCell

        if team?.teamLogo != nil {
            if let imageUrl = URL(string: team!.teamLogo!) {
                cell.teamLogo.kf.setImage(with: imageUrl)
            } else {
                cell.teamLogo.image = UIImage(
                    named: SportType.football.rawValue)
            }
        } else {
            cell.teamLogo.image = UIImage(named: SportType.football.rawValue)
        }
        cell.teamName.text = team?.teamName
        return cell

    }
    func buildCoacheCell(indexPath: IndexPath) -> TeamCollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "TeamCollectionViewCell", for: indexPath)
            as! TeamCollectionViewCell
        cell.teamLogo.image = UIImage(named: SportType.football.rawValue)
        cell.teamName.text = team?.coaches?[indexPath.row].coachName
        return cell

    }
    func buildPlayerCell(indexPath: IndexPath) -> PlayerCardCollectionViewCell {

        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "PlayerCardCollectionViewCell",
                for: indexPath)
            as! PlayerCardCollectionViewCell

        let player = team?.players?[indexPath.row]

        if player?.playerImage != nil {
            if let imageUrl = URL(string: player!.playerImage!) {
                cell.playerImage.kf.setImage(
                    with: imageUrl,
                    placeholder: UIImage(
                        named: self.sportype?.rawValue
                            ?? SportType.football.rawValue)
                )

            } else {
                cell.playerImage.image = UIImage(
                    named: self.sportype?.rawValue
                        ?? SportType.football.rawValue)
            }
        } else {
            cell.playerImage.image = UIImage(
                named: self.sportype?.rawValue ?? SportType.football.rawValue)
        }
        cell.playerName.text = player?.playerName
        cell.playerAge.text =
            ((player?.playerAge) != nil) ? "" : "\(player!.playerAge!) years"
        cell.playerType.text = player?.playerType
        cell.playerNumber.text = player?.playerNumber
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

        case 1:
            title = "Coaches"
        case 2:
            title = "Players"
        default:
            break
        }
        header.titleLabel.text = title
        return header
    }
}
