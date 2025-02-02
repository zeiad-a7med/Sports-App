//
//  LeagueTableViewCell.swift
//  Sports app
//
//  Created by Zeiad on 30/01/2025.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var leaguelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellView.frame = self.bounds
        self.layer.masksToBounds = true

        leagueImage.contentMode = .scaleAspectFill
        leagueImage.layer.masksToBounds = true
        DispatchQueue.main.async {
            self.leagueImage.layer.cornerRadius = 20
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
