//
//  SignUpViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/19.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSecondTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        //Style Element
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(passwordSecondTextField)
        Utilities.styleFilledButton(signUpButton)
        
        let emailImage = UIImage(named:"email")
        Utilities.addLeftImageTo(txtField:emailTextField, andImage: emailImage!)
        let passwordImage = UIImage(named:"password")
        Utilities.addLeftImageTo(txtField: passwordTextField, andImage: passwordImage!)
        Utilities.addLeftImageTo(txtField: passwordSecondTextField, andImage: passwordImage!)
        Utilities.addLeftImageTo(txtField: firstNameTextField, andImage: UIImage(named:"nameIcon")!)
        Utilities.addLeftImageTo(txtField: lastNameTextField, andImage: UIImage(named:"nameIcon")!)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func SignUpAction(_ sender: Any) {
        
        //validaties the text fields  //create user // transfer to home screen
        let error = validations()
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error!
            
        }else{
            // create the user  and jump to tab bar view controller
            //refer: https://firebase.google.com/docs/auth/ios/password-auth
            Auth.auth().createUser(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (success, error) in
                
                if  error != nil{
                    //create user failed
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "Ctrate New User Failed"
                    
                }else{
                    //create user success
                    //refer: https://firebase.google.com/docs/firestore/quickstart
          let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),"lastName":self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), "uid":success!.user.uid]) { (error) in
                        if error == nil {
                            self.errorLabel.alpha = 1
                            self.errorLabel.text = "Add New User to Firebase Failed"
                            
                        }
                        
                    }
             // jump to tob bar view controller 
               let controller = self.storyboard?.instantiateViewController(identifier: "tabBarView") as! TabBarViewController
                                  self.view.window?.rootViewController = controller
                                  self.view.window?.makeKeyAndVisible()
        
                }
                
                
            }
            
        }
        
        
    }
    
    func validations() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill the First Name Field"
        }
        
        if lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill the Last Name Field"
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Pleaase fill the Email Field"
        }
        
        
        if Utilities.validateEmail(emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            
            
            return "Email format is incorrect"
        }
        
        if passwordSecondTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill the Password Field"
        }
        
        let passwordInput = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(passwordInput) == false {
            
            return "Please enter the password containts a special character,a number and at least 7 characters"
        }
        
        
        
        if passwordSecondTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            
            return "The password you entered twice is different"
        }
        
        
        return nil
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(identifier: "displaViewController") as! DisplayViewController
        self.view.window?.rootViewController = controller
        self.view.window?.makeKeyAndVisible()
        
    }
    
 
}
