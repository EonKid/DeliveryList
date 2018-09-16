//
//  UIView+Extension.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit

extension UIView{
    
    func setShadow(){
        let layer: CALayer?         = self.layer
        layer?.cornerRadius         = 5.0
        layer?.masksToBounds        = false
        layer?.shadowOffset         = CGSize(width: -2, height: 2)
        layer?.shadowColor          = UIColor.black.cgColor
        layer?.shadowRadius         = 2.0
        layer?.shadowOpacity        = 0.2
        layer?.shadowPath           = UIBezierPath(roundedRect: layer?.bounds ?? CGRect.zero, cornerRadius: layer?.cornerRadius ?? 0.0).cgPath
        let bColor: CGColor         = (self.backgroundColor?.cgColor)!
        layer?.backgroundColor      = bColor
    }
    
}
