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
    @IBOutlet weak var viewTrailorButton: UIButton!
    @IBOutlet weak var movieDetailStackView: UIStackView!
    @IBOutlet weak var similarMovieLabel: UILabel!
    @IBOutlet weak var similarMovieCollectionView: UICollectionView!
    
    var similarMovies = [MovieData]()
    var movieTrailor = [TrailorData]()
    var trailorKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //similarMovieCollectionView.dataSource = self
        setUI()
        fetchMovieDetail()
        fetchSimilarMovie()
        fetchMovieTrailor()
    }
    
    // Set the UI for detail screen
    func setUI() {
        backdropImage.layer.masksToBounds = false
        movieNameLabel.layer.cornerRadius = 10
        movieNameLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        movieNameLabel.layer.masksToBounds = true
        releaseYearLabel.layer.cornerRadius = 10
        releaseYearLabel.layer.maskedCorners = [.layerMaxXMinYCorner]
        releaseYearLabel.layer.masksToBounds = true
        movieDetailStackView.layer.cornerRadius = 10
        movieDetailStackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        movieDetailStackView.layer.masksToBounds = true
        
        AddfavoritesButton.layer.cornerRadius = 10
        AddfavoritesButton.layer.masksToBounds = true
        AddWatchlistButton.layer.cornerRadius = 10
        AddWatchlistButton.layer.masksToBounds = true
    }
    
    // MARK: - Web request
    // Get movie detail by movieId
    func fetchMovieDetail() {
        var searchURLComponentrs = URLComponents(string: "\(Constants.REQUEST_STRING)/movie/\(Constants.movieId)")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey),
                                            URLQueryItem(name: "language", value: "en-US")]
        
        let jsonURL = searchURLComponentrs?.url
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
                        self.releaseYearLabel.text = " (\(releaseYear))    "
                    }
                }
                if let movieTitle = volumeData.title {
                    DispatchQueue.main.async {
                        self.movieNameLabel.text = "  " + movieTitle
                    }
                }
                if let runTime = volumeData.runtime {
                    DispatchQueue.main.async {
                        self.runTimeLabel.text = "  \(runTime/60)" + "h " + "\(runTime%60)" + "m"
                    }
                }
                if let votes = volumeData.voteCount {
                    DispatchQueue.main.async {
                        self.fansLabel.text = "\(votes)"
                    }
                }
                if let rating = volumeData.voteAvg {
                    DispatchQueue.main.async {
                        self.ratingLabel.text = "\(rating)" + "/10   "
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
    
    func fetchSimilarMovie() {
        self.similarMovies = []
        var searchURLComponentrs = URLComponents(string: "\(Constants.REQUEST_STRING)/movie/\(Constants.movieId)/similar")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey),
                                            URLQueryItem(name: "language", value: "en-US")]
        let jsonURL = searchURLComponentrs?.url
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)
                if let movies = volumeData.results {
                    self.similarMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self.similarMovieCollectionView.reloadData()
                    }
                    
                }
                if self.similarMovies.count == 0 {
                    DispatchQueue.main.async {
                        self.similarMovieLabel.isHidden = true
                        //self.similarMovieCollectionView.isHidden = true
                        self.similarMovieCollectionView.removeFromSuperview()
                    }
                }
                  
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    func fetchMovieTrailor() {
        self.movieTrailor = []
        var searchURLComponentrs = URLComponents(string: "\(Constants.REQUEST_STRING)/movie/\(Constants.movieId)/videos")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey),
                                            URLQueryItem(name: "language", value: "en-US")]
        
        let jsonURL = searchURLComponentrs?.url
        print(jsonURL!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(TrailorVolume.self, from: data!)
                if let movies = volumeData.results {
                    self.movieTrailor.append(contentsOf: movies)
                }
                if self.movieTrailor.count != 0 {
                    DispatchQueue.main.async {
                        self.viewTrailorButton.isHidden = false
                    }
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
        if let trailerKey = self.movieTrailor.first?.trailorPath {
            let url = URL(string:"http://www.youtube.com/watch?v=\(trailerKey)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - Collection view data source

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMovieCell", for: indexPath) as! SimilarMovieCollectionViewCell

        let movie = similarMovies[indexPath.row]
        cell.movieTitleLabel.text = movie.title
        cell.voteAvgLabel.text = String(movie.voteAvg ?? 0.0)
        if movie.posterPath == nil {
            cell.posterImage.image = #imageLiteral(resourceName: "Image_not_found")
        }else{
            cell.posterImage.downloadImage(imageURLString: movie.posterPath!)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Constants.movieId = similarMovies[indexPath.row].id
        //cellIndex = indexPath.row
        let controller = self.storyboard?.instantiateViewController(identifier: "movieDetail") as! MovieDetailViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
