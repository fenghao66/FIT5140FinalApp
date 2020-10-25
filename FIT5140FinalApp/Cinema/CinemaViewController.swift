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
    
    var geometry:[Geometry] = [Geometry]()
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self
        // Do any additional setup after loading the view.
        
     if latitudeCollection.count > 0 {
        
         print("latitudeCollection\(latitudeCollection.count)")
     }else{
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        }
        
        print("4444444444!\(geometry.count)")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMovieDetailAccordingToMovieId(lat: -37.8828617, log: 145.0913041)
    }
    
    
    
    func getMovieDetailAccordingToMovieId(lat:Double,log:Double){
        self.latitudeCollection = [Double]()
        self.longitudeCollection = [Double]()
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
                var i:Int = 1
                if let values = objectData.results{
                    for value in values{
                        self.latitudeCollection.append(value.geometry!.location!.lat!)
                        self.longitudeCollection.append(value.geometry!.location!.lng!)
                        self.geometry.append(value.geometry!)
                    print("Count \(i)")
                           i = i+1;
                        print("name=  \(value.name!)")
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
