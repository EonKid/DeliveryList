//
//  DeliveryModel.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import RealmSwift

class DeliveryModel:  Object {

   @objc dynamic  var deliveryId = Int()
   @objc dynamic  var deliveryDescription = String()
   @objc dynamic  var imageURL = String()
   @objc dynamic  var latitude = Double()
   @objc dynamic  var longitude = Double()
   @objc dynamic  var address = String()
    
    override static func primaryKey() -> String? {
        return "deliveryId"
    }
}
