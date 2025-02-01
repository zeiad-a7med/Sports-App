//
//  FootballEventCollectionViewCell.swift
//  Sports app
//
//  Created by Zeiad on 01/02/2025.
//

import UIKit

class FootballEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var footballEventCardView: UIView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var matchStatusView: UIView!
    @IBOutlet weak var eventResult: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        footballEventCardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        footballEventCardView.frame = self.bounds
        
        self.layer.cornerRadius = 35
        self.layer.masksToBounds = true
        
        //for EventStatus
        matchStatusView.layer.cornerRadius = 10
        matchStatusView.layer.masksToBounds = true
        
        
        homeTeamLogo.contentMode = .scaleAspectFit
        awayTeamLogo.contentMode = .scaleAspectFit
        footballEventCardView.layer.shadowColor = UIColor.black.cgColor
        footballEventCardView.layer.shadowOpacity = 0.2
        footballEventCardView.layer.shadowOffset = CGSize(width: 10, height: 30)
        footballEventCardView.layer.shadowRadius = 10
        footballEventCardView.backgroundColor = .clear

        let layer = CAGradientLayer()
        layer.frame = footballEventCardView.bounds
        layer.colors = ThemeManager.gradientColorsForCard
        layer.startPoint = CGPoint(x: 0, y: 0)   // Top-left corner
        layer.endPoint = CGPoint(x: 1, y: 1)
        footballEventCardView.layer.insertSublayer(layer, at: 0)

    }

}
