//
//  ViewController.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import UIKit
import SVGKit
class HomeViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var myCollectionView: UICollectionView!
    var countriesList: [Country] = []
    var sportsTypesList: [[SportType]] = [
        [.football,.basketball],
        [.tennis,.cricket]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SportCard", bundle: nil)
        self.myCollectionView.register(
            nib, forCellWithReuseIdentifier: "SportCard")
        ThemeManager.addMainBackgroundToView(at: self)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "SportCard", for: indexPath) as! SportCard
        let selectedType = sportsTypesList[indexPath.section][indexPath.row]
        cell.sportImage.image = UIImage(named: selectedType.rawValue)
        cell.sportTitle.text = selectedType.rawValue.capitalized
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        let leftInset =
            (collectionView.layer.frame.size.width
                - CGFloat(UIScreen.main.bounds.size.width) + 20) / 3
        let rightInset = leftInset
        return UIEdgeInsets(
            top: 50, left: leftInset, bottom: 0, right: rightInset)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.size.width / 2-20,
            height: UIScreen.main.bounds.size.height / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(sportsTypesList[indexPath.section][indexPath.row] == .cricket){
            Router.goToLeaguesPage(from: self, sportType: sportsTypesList[indexPath.section][indexPath.row], countryId: nil)
        }else{
            Router.goToCountriesPage(from: self, sportType: sportsTypesList[indexPath.section][indexPath.row])
        }
        
    }

}
