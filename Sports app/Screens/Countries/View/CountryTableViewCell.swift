//
//  CountryTableViewCell.swift
//  Sports app
//
//  Created by Zeiad on 30/01/2025.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countrylabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellView.frame = self.bounds
        self.layer.masksToBounds = true

        countryImage.contentMode = .scaleAspectFill
        countryImage.layer.masksToBounds = true

        DispatchQueue.main.async {
            self.countryImage.layer.cornerRadius = 20
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
