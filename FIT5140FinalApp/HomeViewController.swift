//
//  HomeViewController.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 21/10/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    let REQUEST_STRING = "https://api.themoviedb.org/3"
    let apiKey = "693f8973135b3d30c467e5377ed18164"
    //var listState: String = "popular"
    var newMovies = [MovieData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        self.newMovies = []
        fetchMovie(listState: "popular")
        
        navigationController?.tabBarItem.image = UIImage(named: "home")
        navigationController?.tabBarItem.selectedImage = UIImage(named: "home_click")
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

