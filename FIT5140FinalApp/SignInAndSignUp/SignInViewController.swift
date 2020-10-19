//
//  SignInViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/19.
//

import UIKit

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
    }
}
