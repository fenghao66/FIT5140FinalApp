//
//  MovieDetailViewController.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 22/10/20.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var AddfavoritesButton: UIButton!
    @IBOutlet weak var AddWatchlistButton: UIButton!
    
    var similarMovies = [MovieData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchMovieDetail()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setUI() {
        //backdropImage.layer.masksToBounds = false
        movieNameLabel.layer.cornerRadius = 10
        movieNameLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        movieNameLabel.layer.masksToBounds = true
        releaseYearLabel.layer.cornerRadius = 10
        releaseYearLabel.layer.maskedCorners = [.layerMaxXMinYCorner]
        releaseYearLabel.layer.masksToBounds = true
        
        AddfavoritesButton.layer.cornerRadius = 10
        AddfavoritesButton.layer.masksToBounds = true
        AddWatchlistButton.layer.cornerRadius = 10
        AddWatchlistButton.layer.masksToBounds = true
    }
    
    // MARK: - Web request
    
    func fetchMovieDetail() {
        //self.newMovies = []
        var searchURLComponentrs = URLComponents(string: "\(Constants.REQUEST_STRING)/movie/\(Constants.movieId)")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey),
                                            URLQueryItem(name: "language", value: "en-US")]
        
        let jsonURL = searchURLComponentrs?.url
        print(jsonURL!)
        //print(jsonURL!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
//                self.indicator.stopAnimating()
//                self.indicator.hidesWhenStopped = true
            }

            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)
                if let movieOverview = volumeData.overView {
                    DispatchQueue.main.async {
                        self.overViewLabel.text = movieOverview
                    }
                }
                if let releaseDate = volumeData.releaseDate {
                    let releaseYear = releaseDate[..<releaseDate.range(of: "-")!.lowerBound]
                    DispatchQueue.main.async {
                        self.releaseYearLabel.text = " (\(releaseYear))  "
                    }
                }
                if let movieTitle = volumeData.title {
                    //let releaseYear = releaseDate[..<releaseDate.range(of: "-")!.lowerBound]
                    DispatchQueue.main.async {
                        self.movieNameLabel.text = "   " + movieTitle
                    }
                }
                if let runTime = volumeData.runtime {
                    DispatchQueue.main.async {
                        self.runTimeLabel.text = "\(runTime/60)" + "h " + "\(runTime%60)" + "m"
                    }
                }
                if let votes = volumeData.voteCount {
                    DispatchQueue.main.async {
                        self.fansLabel.text = "\(votes)"
                    }
                }
                if let rating = volumeData.voteAvg {
                    DispatchQueue.main.async {
                        self.ratingLabel.text = "\(rating)" + "/10"
                        //self.homeCollectionView.reloadData()
                    }
                }
                if volumeData.backdropPath == nil {
                    DispatchQueue.main.async {
                        self.backdropImage.image = #imageLiteral(resourceName: "Image_not_found")
                    }
                } else {
                    self.backdropImage.downloadImage(imageURLString: volumeData.backdropPath!)
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    
    @IBAction func addToFavorites(_ sender: Any) {
    }
    
    @IBAction func addToWatchlist(_ sender: Any) {
    }
    
    @IBAction func viewTrailor(_ sender: Any) {
    }
}
