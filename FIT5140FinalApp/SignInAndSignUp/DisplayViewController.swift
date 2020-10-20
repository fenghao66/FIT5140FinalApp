//
//  DisplayViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/19.
//

import UIKit
import AVKit

class DisplayViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    var videoPlayer: AVPlayer?
    //manage the visual output
    var videoPlayerLayer:AVPlayerLayer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //Set Up Video in the background
        setElements()
        setVieo()
    }
    
    
    func setElements(){
        
        Utilities.styleFilledButton(signInButton)
        Utilities.styleHollowButton(SignUpButton)
        
    }
     
    func setVieo(){
        
    //this mehod refer to youtuber Christopher Ching
      let bundlePath = Bundle.main.path(forResource: "cr7", ofType: "MOV")
        guard bundlePath != nil else{
            
            return
        }
       //create the player player
        let item = AVPlayerItem(url: URL(fileURLWithPath: bundlePath!))
        //create the player
        
       
        videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
        
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
