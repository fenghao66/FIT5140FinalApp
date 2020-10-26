//
//  CinemaViewController.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/26.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class CinemaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    var latitudeCollection:[Double] = [Double]()
    var longitudeCollection:[Double] = [Double]()
    var locationName:[String] = [String]()
    var userCurrentLocationLat:Double?
    var userCueentLocationLng:Double?
    var locationManager: CLLocationManager = CLLocationManager()
    let subtitle:String = "Cinema"
    var button: UIButton?
    var selectedLat: Double?
    var selectedLng: Double?
    var selectedName: String?
    var showTableViewBool: Bool = true
    var switchTableViewAndMap:Bool = true
    var userAddressCollection:[String] = [String]()
    var userLatiitudeCollection:[Double] = [Double]()
    var userLongitudeCollection:[Double] = [Double]()
    var userCategoryCollectinon:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // locationManager delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocation()
        //sleep 2 seconds
        //    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        //        self.displayCienmaFromMapAPI()
        //      })
        if showTableViewBool{
            tableView.isHidden = true
        }
    getUserData()
        
    }
    
    
    @IBAction func listAction(_ sender: Any) {
        if switchTableViewAndMap{
            mapView.isHidden = true
            tableView.isHidden = false
            switchTableViewAndMap = false
            listButton.title = "Back Map"
        }else{
            mapView.isHidden = false
            tableView.isHidden = true
            switchTableViewAndMap = true
            listButton.title = "List"
        }
        
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
            DispatchQueue.main.async {
                self.mapView.addAnnotation(_annotation)
            }
        }
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserData(){
        let uid = Auth.auth().currentUser?.uid
        //get data
        //refer https://firebase.google.com/docs/firestore/quickstart
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
                 DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                    if self.userAddressCollection.count  == 0{
                        
                        print("xx@@@@@@@@@@@@@@@@@@@@@@@@@xx")
                    }else{
                                        
                        print("#################\(self.userAddressCollection[0])")
                    }
                    
                }else{
                    
                    print("get data error: \(String(describing: error))")
                }
            }
        }
    }
    
    
    
}

extension CinemaViewController: MKMapViewDelegate{
    
    func focusOn(annotation: MKAnnotation){
        mapView.selectAnnotation(annotation, animated: true)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedLat = view.annotation?.coordinate.latitude
        self.selectedLng = view.annotation?.coordinate.longitude
        self.selectedName = view.annotation?.title as! String
        focusOn(annotation: view.annotation!)        
    }
    
    // This refer to Youtube:https://youtu.be/w_aw72i8P_U
    //https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started#toc-anchor-012
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is locationAnnotation else { return nil}
        
        let _identifier = "annotation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: _identifier) as? MKMarkerAnnotationView{
            
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        }else{
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: _identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .infoDark)
            button = view.rightCalloutAccessoryView as? UIButton
            button?.addTarget(self, action: #selector(jumpToAnotherScreen), for: .touchUpInside)
        }
        return view
    }
    
    @objc func jumpToAnotherScreen(sender: UIButton){
        print("success")
        jumpToAppleMapNavigation(lat: self.selectedLat!, lng: self.selectedLng!)
    }
    
    
    func jumpToAppleMapNavigation(lat:Double,lng:Double){
        //refer to https://youtu.be/INfCmCxLC0o
        let coordinates = CLLocationCoordinate2DMake(lat,lng)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.selectedName
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    
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

extension CinemaViewController: UITableViewDelegate{
    
}
extension CinemaViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return self.userLatiitudeCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = self.userAddressCollection[indexPath.row]
    cell.detailTextLabel?.text = "Category: " + self.userCategoryCollectinon[indexPath.row]
        
        return cell
    }
}
