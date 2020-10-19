//
//  DisplayViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/19.
//

import UIKit

class DisplayViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       setElements()
        // Do any additional setup after loading the view.
    }

    func setElements(){
        
        Utilities.styleFilledButton(signInButton)
        Utilities.styleHollowButton(SignUpButton)
        
    }
     
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func signInAction(_ sender: Any) {
    }
    
    
    @IBAction func SignUpAction(_ sender: Any) {
    }
}
