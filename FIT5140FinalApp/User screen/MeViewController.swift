//
//  MeViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/20.
//

import UIKit
import FirebaseAuth
import Firebase

class MeViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var favoriteView: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    var favoriet:[Int] = [Int]()
    var watched:[Int] = [Int]()
    var movieCollection:[MovieDetailNew] = [MovieDetailNew]()
    var movieDEtail:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.favoriteView.collectionViewLayout = layout
        userImage.image = #imageLiteral(resourceName: "user_click")
        
        // costom the tabBar item
        navigationController?.tabBarItem.selectedImage = UIImage(named: "user_click")
        
        Utilities.signOutButton(logOutButton)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
     getUserData()
     print("!!!!!! movie Collection \(self.movieCollection.count)")
      
    
    }
    
    
    func getUserData(){
        let uid = Auth.auth().currentUser?.uid
        
        //get data
        //refer https://firebase.google.com/docs/firestore/quickstart
        let db = Firestore.firestore()
        
        db.collection("users").document(uid!).getDocument { (query, error) in
            if error == nil{
                if query != nil && query!.exists{
                    let documentData = query?.data()
                    let first_name: String = documentData!["firstName"] as! String
                    let last_name: String = documentData!["lastName"] as! String
                    self.firstNameLabel.text = first_name + " . " + last_name
                    self.favoriet = documentData!["favorites"] as! [Int]
                    self.watched = documentData!["watched"] as! [Int]
                    
                    if self.favoriet.count == 0{
                        
                        print("@@@@@@@@@@@@@@@@@@@@@@@@@")
                    }else{
                        self.refreshMovieDetailCollection(idCollection: self.favoriet)
                      
                        print("#################\(self.favoriet[0])")
                    }
                                  
                }else{
                    
                    print("get data error: \(String(describing: error))")
                }
            }
        }
    }
    
    func  refreshMovieDetailCollection(idCollection:[Int]){
        
        print("idCollection size \(idCollection.count)")
        
        for id in idCollection{
            
            getMovieDetailAccordingToMovieId(id: id)
        }
        
        
    }
    
    @IBAction func fetchFavoriteAction(_ sender: Any) {
        self.refreshMovieDetailCollection(idCollection: self.favoriet)
        
    }
    
    
    @IBAction func fetchWatchedAction(_ sender: Any) {
        self.refreshMovieDetailCollection(idCollection: self.watched)
    }
    
    func getMovieDetailAccordingToMovieId(id: Int){
       movieCollection = [MovieDetailNew]()
        let searchString = Constants.REQUEST_STRING + "/movie/\(id)?api_key=" + Constants.apiKey + "&append_to_response=videos"
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)!)
        print(jsonURL ?? " jsonUrl failed")
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            if let error = error {
                print(error)
                return
            }
            do{
                let decoder = JSONDecoder()
          let objectData = try decoder.decode(MovieDetailNew.self, from: data!)
//                if let movieOverview = objectData.overView {
//                      DispatchQueue.main.async {
//                        self.movieDEtail.append(movieOverview)
//                        print("movieOverview!!!" + movieOverview)
//                                 }
//                             }
                self.movieCollection.append(objectData)
                DispatchQueue.main.async {
                    self.favoriteView.reloadData()
                }
             
            }catch let error{
                print(error)
            }
        }
        
        task.resume()
        
        
    }
    
    // sign Out action
    @IBAction func logOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Out", message: "Do you want to Sign Out", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (action) in
            // sign out
            do{
                try Auth.auth().signOut()
                let controller = self.storyboard?.instantiateViewController(identifier: "displaViewController") as! DisplayViewController
                self.view.window?.rootViewController = controller
                self.view.window?.makeKeyAndVisible()
                
            }catch let error {
                print("sign out failed \(error)")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
}
extension MeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      

      
     return  movieCollection.count
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionCollectionViewCell
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 10
        cell.layer.masksToBounds = false
        let movieDetail = movieCollection[indexPath.row]
        if movieDetail.backdrop_path == nil {
            cell.posterImage.image = UIImage(named: "Image_not_found")
        }else{
            
            cell.posterImage.downloadPoster(imageURLString: movieDetail.backdrop_path!)
        }
        
        cell.titleLabel.text = movieDetail.title!
        cell.ratingLabel.text = "\(movieDetail.voteAvg!)"
        
        return cell
    }
    
    
    
    
}
extension MeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 166, height: 339)
    }
}

extension UIImageView{

 func downloadPoster(imageURLString: String) {
    
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
