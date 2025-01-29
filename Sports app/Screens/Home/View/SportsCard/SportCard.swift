//
//  SportCard.swift
//  Sports app
//
//  Created by Zeiad on 29/01/2025.
//

import UIKit

import UIKit

class SportCard: UICollectionViewCell {

    @IBOutlet weak var sportCardView: UIView!
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!
    @IBOutlet weak var imageOverlay: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        sportCardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sportCardView.frame = self.bounds
        
        self.layer.cornerRadius = 10 
        self.layer.masksToBounds = true
        
        sportImage.contentMode = .scaleAspectFill
        sportImage.clipsToBounds = true
        sportImage.frame = sportImage.bounds
        sportImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sportCardView.addSubview(sportImage)
        sportImage.addSubview(imageOverlay)
    }
    
}
