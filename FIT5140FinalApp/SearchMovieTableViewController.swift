//
//  SearchMovieTableViewController.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 19/10/20.
//

import UIKit

class SearchMovieTableViewController: UITableViewController {

    let REQUEST_STRING = "https://api.themoviedb.org/3"
    let apiKey = "693f8973135b3d30c467e5377ed18164"

    var image:UIImage = UIImage()
    var newMovies = [MovieData]()
    
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for movies"
        //.searchBar.autocapitalizationType = .none

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        //navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
        
        navigationController?.tabBarItem.image = UIImage(named: "search")
        navigationController?.tabBarItem.selectedImage = UIImage(named: "search_click")
    }
    
    func searchMovie(query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        var searchURLComponentrs = URLComponents(string: "\(REQUEST_STRING)/search/movie")
        searchURLComponentrs?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                           URLQueryItem(name: "language", value: "en-US"),
                                           URLQueryItem(name: "include_adult", value: "false"),
                                           URLQueryItem(name: "query", value: query)]
        
        let jsonURL = searchURLComponentrs?.url
        //print(jsonURL!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
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
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieCell", for: indexPath) as! SearchMovieCell
        let movie = newMovies[indexPath.row]
        
        cell.movieName.text = movie.title
        //cell.releaseYear.text = dateFormatter.string(from: movie.releaseDate)
        cell.movieOverview.text = movie.overview
        if movie.posterPath == nil {
            cell.posterImage.image = nil
        }else{
            cell.posterImage.downloadImage(imageURLString: movie.posterPath!)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
  
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchMovieTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
        return;
        }
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        self.newMovies = []
        searchMovie(query: searchText)
    }
    
}
extension UIImageView{

 func downloadImage(imageURLString: String) {
    
    let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(imageURLString)")!
    let task = URLSession.shared.dataTask(with: imageURL) {
        (data, response, error) in
            
        if error != nil{
                print(error!)
                return
            }
        DispatchQueue.main.async {
            self.image = UIImage(data: data!)!
            }
        }
        task.resume()
    }
}
