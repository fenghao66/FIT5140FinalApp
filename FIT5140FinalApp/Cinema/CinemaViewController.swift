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
    var locationName:[String] = [String]()
    var userCurrentLocationLat:Double?
    var userCueentLocationLng:Double?
    var locationManager: CLLocationManager = CLLocationManager()
    let subtitle:String = "Cinema"
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // locationManager delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocation()
        //sleep 2 seconds
        //    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        //        self.displayCienmaFromMapAPI()
        //      })
    }
    
    
    
    func checkLocation(){
        if CLLocationManager.locationServicesEnabled() {
            validateLocationAuth()
            
        }else {
            print("CLLocationManager failed !!!")
        }
        
    }
    
    func validateLocationAuth(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            loadMap()
            break
        case .denied:
            displayMessage(title: "Reopen Authentication", message: "Settings-> Privacy->Location Services->Open")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            displayMessage(title: "Filed", message: "Map Service Restricted")
            break
        case .authorizedAlways:
            loadMap()
            break
        }
    }
    func  loadMap(){
        mapView.showsUserLocation = true
        if let currentLocation = locationManager.location?.coordinate {
            //print cuttentLocation lat && lng
            userCurrentLocationLat = currentLocation.latitude
            userCueentLocationLng = currentLocation.longitude
            print("current location lat \(currentLocation.latitude)")
            print("current location lng \(currentLocation.longitude)")
            let region = MKCoordinateRegion.init(center: currentLocation, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
            mapView.setRegion(region, animated: true)
        }
        locationManager.startUpdatingLocation()
        self.getCinemaAccordingToUserCurrentLocation(lat: self.userCurrentLocationLat!, log: self.userCueentLocationLng!)
    }
    
    
    
    func getCinemaAccordingToUserCurrentLocation(lat:Double,log:Double){
        self.latitudeCollection = [Double]()
        self.longitudeCollection = [Double]()
        self.locationName = [String]()
        let searchString = Constants.MAP_REQUEST + "\(lat),\(log)&radius=8000&type=movie_theater&key="+Constants.MAP_KEY
        
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
                        self.locationName.append(value.name!)
                        print("##### \(self.latitudeCollection.count)")
                        
                    }
                    
                    self.displayCienmaFromMapAPI()
                    
                }
                
            }catch let error{
                print("!!!!!!!!!!!!!"+error.localizedDescription)
            }
        }
        
        task.resume()
        
        
    }
    
    func displayCienmaFromMapAPI(){
        let number = self.longitudeCollection.count
        print("number couunt \(number)")
        for i in 0..<number{
            let _annotation = locationAnnotation(title: self.locationName[i], subtitle: self.subtitle, lat: self.latitudeCollection[i], lng: self.longitudeCollection[i])
            mapView.addAnnotation(_annotation)
        }
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

extension CinemaViewController: MKMapViewDelegate{
    
    
    
    
    
}


extension CinemaViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        validateLocationAuth()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            
            print("failed")
            return
        }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
        mapView.setRegion(region, animated: true)
    }
    
    
}
