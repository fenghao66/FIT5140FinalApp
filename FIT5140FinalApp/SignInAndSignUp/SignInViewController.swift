//
//  SignInViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/19.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setSignElements(){
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(signInButton)        
        let emailImage = UIImage(named:"email")
        Utilities.addLeftImageTo(txtField:emailTextField, andImage: emailImage!)
        let passwordImage = UIImage(named:"password")
        Utilities.addLeftImageTo(txtField: passwordTextField, andImage: passwordImage!)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func SignInAction(_ sender: Any) {
        //validate the text field and password feld in order to make sure that all text field are filled
        let validateMessage =  validations()
        if validateMessage != nil{
            errorLabel.alpha = 1
            errorLabel.text = validateMessage
            
        }else{
            //Sign in
            //refer:https://firebase.google.com/docs/auth/ios/password-auth
            Auth.auth().signIn(withEmail: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (success, error) in
                if error != nil{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error?.localizedDescription
                    
                }else{
                    // jump to tob bar view controller
                    let controller = self.storyboard?.instantiateViewController(identifier: "tabBarView") as! TabBarViewController
                    self.view.window?.rootViewController = controller
                    self.view.window?.makeKeyAndVisible()
                    
                    
                }
                
                
            }   
        }
        
        
    }
    
    
    func validations() -> String?{
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill the exmail text field"
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill the password text field"
        }
        return nil
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "displaViewController") as! DisplayViewController
        self.view.window?.rootViewController = controller
        self.view.window?.makeKeyAndVisible()
        
    }
    
}

//refer :https://kaushalelsewhere.medium.com/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
extension UIViewController{
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
