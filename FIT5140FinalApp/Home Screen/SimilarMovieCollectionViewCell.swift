//
//  similarMovieCollectionViewCell.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 24/10/20.
//

import UIKit

class SimilarMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var voteAvgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 6.0
        posterImage.layer.masksToBounds = true
    }
}
