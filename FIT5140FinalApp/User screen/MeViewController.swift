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

    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var WatchedView: UICollectionView!
    @IBOutlet weak var favorietView: UICollectionView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//    let user = Auth.auth().currentUser
//      if let user = user {
//      // The user's ID, unique to the Firebase project.
//      // Do NOT use this value to authenticate with your backend server,
//      // if you have one. Use getTokenWithCompletion:completion: instead.
//      let uid = user.uid
//      let email = user.email
//        firstNameLabel.text = email!
//        lastNameLabel.text = user.displayName!
//      }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       self.favorietView.collectionViewLayout = layout
        userImage.image = UIImage(named: "test")
    
        // costom the tabBar item
        navigationController?.tabBarItem.selectedImage = UIImage(named: "user_click")
    }
    

}
extension MeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == favorietView){
            return 30;
        }
        
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == WatchedView){
            let cell1 = WatchedView.dequeueReusableCell(withReuseIdentifier: "watchedCell", for: indexPath) as! WatchedCollectionViewCell
            cell1.watchedImage.image = #imageLiteral(resourceName: "test")
            return cell1
            
        }
        
        
        let cell = favorietView.dequeueReusableCell(withReuseIdentifier: "favorietCell", for: indexPath) as! FavorietCollectionViewCell
        
        cell.favorietImage.image = UIImage(named: "test")
        return cell
    }
    
    
    
    
}
extension MeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if (collectionView == WatchedView){
        return CGSize(width: 170, height: 150)
        }
        
    return CGSize(width: 170, height: 150)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if (collectionView == WatchedView){
               return 10
         }
               
           return 10
    }
    
}
