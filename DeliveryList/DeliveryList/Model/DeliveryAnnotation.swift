//
//  DeliveryAnnotation.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DeliveryAnnotation: NSObject , MKAnnotation{
    
    var coordinate = CLLocationCoordinate2D()
    var title : String?
    
    init(coordiante coordinate: CLLocationCoordinate2D,title: NSString) {
        self.coordinate = coordinate
        self.title = title as String
    }
   
}
