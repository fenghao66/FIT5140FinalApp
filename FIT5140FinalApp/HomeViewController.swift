//
//  HomeViewController.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 21/10/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var nowPlayingButton: UIButton!
    @IBOutlet weak var upComingButton: UIButton!
    
    let REQUEST_STRING = "https://api.themoviedb.org/3"
    let apiKey = "693f8973135b3d30c467e5377ed18164"
    //var selectState: String = "popular"
    var newMovies = [MovieData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        //self.newMovies = []
        fetchMovie(listState: "popular")
        
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        //tabBar.barTintColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.gray.cgColor
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.tabBarItem.selectedImage = UIImage(named: "home_click")
        
        popularButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @IBAction func showPopularMovies(_ sender: Any) {
        popularButton.setTitleColor(UIColor.black, for: .normal)
        nowPlayingButton.setTitleColor(UIColor.darkGray, for: .normal)
        upComingButton.setTitleColor(UIColor.darkGray, for: .normal)
        fetchMovie(listState: "popular")
    }
    
    @IBAction func showNowPlayingMovies(_ sender: Any) {
        nowPlayingButton.setTitleColor(UIColor.black, for: .normal)
        popularButton.setTitleColor(UIColor.darkGray, for: .normal)
        upComingButton.setTitleColor(UIColor.darkGray, for: .normal)
        fetchMovie(listState: "now_playing")
    }
    @IBAction func showUpcomingMovies(_ sender: Any) {
        upComingButton.setTitleColor(UIColor.black, for: .normal)
        popularButton.setTitleColor(UIColor.darkGray, for: .normal)
        nowPlayingButton.setTitleColor(UIColor.darkGray, for: .normal)
        fetchMovie(listState: "upcoming")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Web request
    
    func fetchMovie(listState: String?) {
        self.newMovies = []
        var searchURLComponentrs = URLComponents(string: "\(REQUEST_STRING)/movie/\(listState ?? "popular")")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        let jsonURL = searchURLComponentrs?.url
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
                if let movies = volumeData.results {
                    self.newMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }

}
// MARK: - Collection view data source

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let movie = newMovies[indexPath.row]
        
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 10
        cell.layer.masksToBounds = false

        cell.movieTitleLabel.text = movie.title
        cell.releaseYearLabel.text = movie.releaseDate
        if movie.posterPath == nil {
            cell.posterImage.image = nil
        }else{
            cell.posterImage.downloadImage(imageURLString: movie.posterPath!)
        }
        return cell
    }
}


