//
//  CinemaViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/26.
//

import UIKit
import MapKit

class CinemaViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var latitudeCollection:[Double] = [Double]()
    var longitudeCollection:[Double] = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCinemaAccordingToUserCurrentLocation(lat: -37.8828617, log:145.0913041)
//    self.perform(#selector(latitudeCollectionCount), with: nil, afterDelay: 3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.latitudeCollectionCount()
        })
    }
   // @objc
    func  latitudeCollectionCount(){
        var id:Int = 1
        
        if self.latitudeCollection.count > 0 {
            
            print("%%%%%%%%%%\(self.latitudeCollection.count)")
        }
        
        for test  in self.latitudeCollection{
           print("loop: \(test)")
           print("count!!: \(id)")
            id = id+1
            
        }
    }
    
    
    func getCinemaAccordingToUserCurrentLocation(lat:Double,log:Double){
        //self.latitudeCollection = []
        
        let searchString = Constants.MAP_REQUEST + "\(lat),\(log)&radius=15000&type=movie_theater&key="+Constants.MAP_KEY
        
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)!)
        print(jsonURL ?? " jsonUrl failed")
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            if let error = error {
                print("#########"+error.localizedDescription)
                return
            }
            do{
                let decoder = JSONDecoder()
                let objectData = try decoder.decode(nearByCinema.self, from: data!)
                if let values = objectData.results{
                    
                    for value in values{
                        let latResult: Double = value.geometry!.location!.lat!
                        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
                        print("test : \(latResult)")
                        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
                        print("")
                        
                        self.latitudeCollection.append(latResult)
                        self.longitudeCollection.append(value.geometry!.location!.lng!)
                        print("##### \(self.latitudeCollection.count)")
                        
                    }
                }
                
            }catch let error{
                print("!!!!!!!!!!!!!"+error.localizedDescription)
            }
        }
        
        task.resume()
        
        
    }
    
    
    
    
}

extension CinemaViewController: MKMapViewDelegate{
    
    
    
    
    
}
