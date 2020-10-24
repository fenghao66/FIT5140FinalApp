//
//  EditMeViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/24.
//

import UIKit
import FirebaseAuth
import Firebase

class EditMeViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UITextField!
    
    @IBOutlet weak var lastNameLabel: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utilities.styleTextField(firstNameLabel)
        Utilities.styleTextField(lastNameLabel)
        Utilities.addLeftImageTo(txtField: firstNameLabel, andImage: UIImage(named:"nameIcon")!)
        Utilities.addLeftImageTo(txtField: lastNameLabel, andImage: UIImage(named:"nameIcon")!)
        
        Utilities.styleFilledButton(changePasswordButton)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let firstName = firstNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstName == "" && lastName == ""{
            self.displayMessage(title: "Failed", message: "Please fill one of the text fields")
        }
        
        if firstName != "" && lastName != ""{
            updatedate(name: "firstName", value: firstName!)
            updatedate(name: "lastName", value: lastName!)
        }else if firstName == "" && lastName != ""{
            updatedate(name: "lastName", value: lastName!)
        }else if firstName != "" && lastName == "" {
            updatedate(name: "firstName", value: firstName!)
        }
        
    }
    
    
    func updatedate(name: String,value: String) {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).updateData(["\(name)": value]) { (error) in
            if let error = error{
                self.displayMessage(title: "Failed", message: error.localizedDescription)
            }else {
                self.displayMessage(title: "Success", message: "User Data update successfully")
                
            }
        }
        
        
        
        
        
    }
    
    
    @IBAction func changePasswordAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "What's your register email ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Input register email"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action) in
            let email = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if email != "" && Utilities.validateEmail(email!){
                //sendreset password email
                Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                    if error != nil{
                        self.displayMessage(title: "Failed", message: error!.localizedDescription)
                        
                    }else{
                        self.displayMessage(title: "Success", message: "Reset password email has been sent to your email address ")
                        
                    }
                }
                
            }else if email == "" {
                self.displayMessage(title: "Sorry", message: "Input email cannot be empty")
                
            }else if !Utilities.validateEmail(email!){
                self.displayMessage(title: "Sorry", message: "Input email format is incorrect")
                
            }
            
        }))
        
        self.present(alert,animated: true)
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
