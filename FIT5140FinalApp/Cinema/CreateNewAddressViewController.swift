//
//  CreateNewAddressViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/27.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class CreateNewAddressViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var newAddressCategory: UISegmentedControl!
    @IBOutlet weak var newAddressTextField: UITextField!
    var userCurrentLocationLat:Double?
    var userCueentLocationLng:Double?
    var locationManager: CLLocationManager = CLLocationManager()
    var saveLat:Double?
    var saveLng:Double?
    var saveCategory:String?
    var uId:String?
    var userAddressCollection:[String] = [String]()
    var userLatiitudeCollection:[Double] = [Double]()
    var userLongitudeCollection:[Double] = [Double]()
    var userCategoryCollectinon:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Utilities.styleTextField(newAddressTextField)
        // Do any additional setup after loading the view.
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        getUserCurrentLocation()
    }
    
    @IBAction func saveNewAddress(_ sender: Any) {
        
        if  Validation() == true{
            
            //save data
         let address = newAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
        do {
                 
            
            userAddressCollection.append(address!)
           try updateDataString(name: "address", value: userAddressCollection)
            
            userCategoryCollectinon.append(saveCategory!)
          try  updateDataString(name: "Category", value: userCategoryCollectinon)
            
            userLatiitudeCollection.append(saveLat!)
          try  updateDataDouble(name: "lat", value: userLatiitudeCollection)
            
            userLongitudeCollection.append(saveLng!)
          try  updateDataDouble(name: "lng", value: userLongitudeCollection)
        } catch is Error {
            print("Save failed \(Error.self)")
            }
      displayMessage(title: "Success", message: "Save New Address Successfully")
            
        }else{
            
            displayMessage(title: "Save Failed", message: "Maybe some fields are incorrectly filled")
        }
        
    }
    
    func updateDataString(name: String,value: [String]){
            let db = Firestore.firestore()
    //        let uid = Auth.auth().currentUser?.uid
            db.collection("users").document(self.uId!).updateData(["\(name)": value]) { (error) in
                if let error = error{
                    self.displayMessage(title: "Failed", message: error.localizedDescription)
                }else {
                   
                    
                }
            }
            
        }
    func updateDataDouble(name: String,value: [Double]){
            let db = Firestore.firestore()
    //        let uid = Auth.auth().currentUser?.uid
            db.collection("users").document(self.uId!).updateData(["\(name)": value]) { (error) in
                if let error = error{
                    self.displayMessage(title: "Failed", message: error.localizedDescription)
                }else {
                   
                    
                }
            }
            
        }
    
    func getUserCurrentLocation(){
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
               
    }
    
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        saveLat = userCurrentLocationLat
        saveLng = userCueentLocationLng
        displayMessage(title: "Success", message: "Save Current Location Successfully")
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
    alertController.addAction(UIAlertAction(title: "Dismiss",style: UIAlertAction.Style.default,handler: nil))
        
    self.present(alertController, animated: true, completion: nil)
    }
    
    
    func Validation() -> Bool{
      
        if newAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            displayMessage(title: "Failed", message: "Please fill the new address name")
          return false
        }
      
        do {
            try saveCategory = newAddressCategory.titleForSegment(at: newAddressCategory.selectedSegmentIndex)
        } catch is Error {
            print("new Catrgory is \(Error.self)")
        }
        if saveCategory == nil {
            displayMessage(title: "Failed", message: "Please choose the category type")
            
            return false
        }
        
        if saveLat == nil && saveLng == nil {
                displayMessage(title: "Failed", message: "Please long tap on map in order to add location")
                  
                  return false
              }
        
      return true
    }
    
    func getUserData(){
        let uid = Auth.auth().currentUser?.uid
        self.uId = uid
        //get data
        //refer https://firebase.google.com/docs/firestore/quickstart
       userAddressCollection = [String]()
       userLatiitudeCollection = [Double]()
       userLongitudeCollection = [Double]()
       userCategoryCollectinon = [String]()
        let db = Firestore.firestore()
        db.collection("users").document(uid!).getDocument { (query, error) in
            if error == nil{
                if query != nil && query!.exists{
                    let documentData = query?.data()
                    let userAddress:[String] = documentData!["address"] as! [String]
                    let userCategoory:[String] = documentData!["Category"] as! [String]
                    let userLat:[Double] = documentData!["lat"] as! [Double]
                    let userLng:[Double] = documentData!["lng"] as! [Double]
                    self.userAddressCollection = userAddress
                    self.userCategoryCollectinon = userCategoory
                    self.userLatiitudeCollection = userLat
                    self.userLongitudeCollection = userLng
                    if self.userAddressCollection.count  == 0{
                        
                        print("xx@@@@@@@@@@@@@@@@@@@@@@@@@xx")
                    }else{
                                        
                        print("#################\(self.userAddressCollection.count)")
                    }
                    
                }else{
                    
                    print("get data error: \(String(describing: error))")
                }
            }
        }
    }
    
    
   @objc func longTap(sender: UITapGestureRecognizer){
        print("long tap Success")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            print("lat \(locationOnMap.latitude)")
            print("lng \(locationOnMap.longitude)")
            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        // locationlIST.removeAll()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        if newAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            annotation.title = newAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }else{
            annotation.title = "New Address"
        }
        
        
        annotation.subtitle = saveCategory
        self.mapView.addAnnotation(annotation)
        // locationlIST.append(location)
        saveLat = location.latitude
        saveLng = location.longitude
        
        print("save LAT \(saveLat)")
    }
    
   
}

extension CreateNewAddressViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//           guard let location = locations.last else {
//
//               print("failed")
//               return
//           }
//           let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
//           mapView.setRegion(region, animated: true)
//       }
    
}
