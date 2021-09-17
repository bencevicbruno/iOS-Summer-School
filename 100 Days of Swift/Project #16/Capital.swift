//
//  Capital.swift
//  Project #16
//
//  Created by Bruno Benčević on 8/13/21.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
   
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coord: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coord
        self.info = info
    }
}
