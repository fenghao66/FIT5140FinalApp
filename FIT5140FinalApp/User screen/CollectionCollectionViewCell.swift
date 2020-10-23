//
//  CollectionCollectionViewCell.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/22.
//

import UIKit

class CollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 10.0
        posterImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        posterImage.layer.masksToBounds = true
    }
}
