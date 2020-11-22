//
//  ForgetPasswordViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/20.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(confirmButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func confirmAction(_ sender: Any) {
        
        let error = validation()
        if error != nil{
            errorLabel.alpha = 1
            errorLabel.text = error
            
        }else{
            //reset password request
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (error) in
                if error != nil{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error?.localizedDescription
                    
                }else{
                    self.errorLabel.alpha = 0
                    
                    self.displayMessage(title: "Success!", message: "Reset password email has been sent to your email address ")
                    
                }
            }
            
            
            
        }
        
    }
    
    
    func validation() -> String?{
        if Utilities.validateEmail(emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
                   
                   
                   return "Email format is incorrect"
          }
      if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Pleaase fill the Email Field"
        }
        
        
        return nil
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
        self.view.window?.rootViewController = controller
        self.view.window?.makeKeyAndVisible()
    }
    
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

