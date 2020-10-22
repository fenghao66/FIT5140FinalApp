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
       self.favoriteView.collectionViewLayout = layout
        userImage.image = #imageLiteral(resourceName: "user_click")
    
        // costom the tabBar item
        navigationController?.tabBarItem.selectedImage = UIImage(named: "user_click")
        
        Utilities.signOutButton(logOutButton)
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
        
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionCollectionViewCell
        cell.layer.cornerRadius = 10.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 10
        cell.layer.masksToBounds = false
        cell.posterImage.image = UIImage(named: "test")
        return cell
    }
    
    
    
    
}
extension MeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 166, height: 339)
    }
}
