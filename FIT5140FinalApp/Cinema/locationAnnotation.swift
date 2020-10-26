//
//  locationAnnotation.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/26.
//

import UIKit
import MapKit

class locationAnnotation: NSObject, MKAnnotation {

     var title: String?
     var subtitle: String?
     var coordinate: CLLocationCoordinate2D
     //var imageName: String?
       init(title: String, subtitle: String, lat: Double, lng: Double) {
           self.title = title
           self.subtitle = subtitle
           self.coordinate = CLLocationCoordinate2DMake(lat, lng)
           //self.imageName = imageName
           
       }
    
    
}
