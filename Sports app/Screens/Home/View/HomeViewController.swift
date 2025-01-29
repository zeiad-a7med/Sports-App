//
//  ViewController.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var myCollectionView: UICollectionView!
    var countriesList: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SportCard", bundle: nil)
        self.myCollectionView.register(
            nib, forCellWithReuseIdentifier: "SportCard")
        self.tabBarItem.title = "Sasports"

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
        cell.sportImage.image = UIImage(named: "basketball")
        cell.sportTitle.text = "Sport\(indexPath.row)"
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
        Router.goToCountriesPage(from: self, sportName: "football")
    }

}
