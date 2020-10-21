//
//  HomeCollectionViewCell.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 21/10/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 10.0
        posterImage.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        posterImage.layer.masksToBounds = true
    }
    
//    var movie: MovieData! {
//        didSet {
//            self.updateUI()
//        }
//    }
//
//    func updateUI() {
//        if let movie = movie {
//
//        }
//    }
}
