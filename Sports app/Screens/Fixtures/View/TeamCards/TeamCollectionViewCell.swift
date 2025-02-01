//
//  TeamCollectionViewCell.swift
//  Sports app
//
//  Created by Zeiad on 01/02/2025.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        teamView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        teamView.frame = self.bounds
        
        self.layer.cornerRadius = 35
        self.layer.masksToBounds = true
        
        
        teamLogo.contentMode = .scaleAspectFit
        
        teamView.layer.shadowColor = UIColor.black.cgColor
        teamView.layer.shadowOpacity = 0.2
        teamView.layer.shadowOffset = CGSize(width: 10, height: 10)
        teamView.layer.shadowRadius = 10
        teamView.backgroundColor = .clear

        let layer = CAGradientLayer()
        layer.frame = teamView.bounds
        layer.colors = ThemeManager.gradientColorsForCard
        layer.startPoint = CGPoint(x: 0, y: 0)   // Top-left corner
        layer.endPoint = CGPoint(x: 1, y: 1)
        teamView.layer.insertSublayer(layer, at: 0)

    }

}
