//
//  DeliveryListTableViewCell.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import SnapKit

class DeliveryListTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    let viewContainer = UIView()

   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialUISetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //MARK: - Functions
    
    func initialUISetup()  {
        
        //Postion viewContainer
        self.contentView.addSubview(viewContainer)
        self.viewContainer.backgroundColor = UIColor.white
        self.viewContainer.layer.cornerRadius = 8.0
        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
        
        
    }

}