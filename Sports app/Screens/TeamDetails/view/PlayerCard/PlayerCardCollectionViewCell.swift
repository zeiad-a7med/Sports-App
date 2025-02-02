//
//  PlayerCardCollectionViewCell.swift
//  Sports app
//
//  Created by Zeiad on 02/02/2025.
//

import UIKit

class PlayerCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerType: UILabel!
    @IBOutlet weak var playerAge: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    private func setup() {
        playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.frame = self.bounds
        
        self.layer.cornerRadius = 35
        self.layer.masksToBounds = true
        
        //for EventStatus
        playerView.layer.cornerRadius = 10
        playerView.layer.masksToBounds = true
        
        
        playerImage.contentMode = .scaleAspectFit
        playerImage.layer.cornerRadius = 10
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 0.2
        playerView.layer.shadowOffset = CGSize(width: 10, height: 30)
        playerView.layer.shadowRadius = 10
        playerView.backgroundColor = .clear

        let layer = CAGradientLayer()
        layer.frame = playerView.bounds
        layer.colors = ThemeManager.gradientColorsForCard
        layer.startPoint = CGPoint(x: 0, y: 0)   // Top-left corner
        layer.endPoint = CGPoint(x: 1, y: 1)
        playerView.layer.insertSublayer(layer, at: 0)

    }

}
