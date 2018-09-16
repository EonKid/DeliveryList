//
//  DeliveryListTableViewCell.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class DeliveryListTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    let viewContainer = UIView()
    let imageViewPlaceholder = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialUISetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //MARK: - Functions
    
    func initialUISetup()  {
        
        //Position viewContainer
        self.contentView.addSubview(viewContainer)
        self.viewContainer.backgroundColor = UIColor.white
        self.viewContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(8, 16, 8, 16))
        }
        
        //Position placeholder view
        self.viewContainer.addSubview(self.imageViewPlaceholder)
        self.imageViewPlaceholder.backgroundColor = UIColor.groupTableViewBackground
        self.imageViewPlaceholder.layer.cornerRadius = 8.0
        self.imageViewPlaceholder.contentMode = .scaleAspectFill
        self.imageViewPlaceholder.clipsToBounds = true
        self.imageViewPlaceholder.snp.makeConstraints { (make) in
            make.left.equalTo(self.viewContainer).offset(8)
            make.centerY.equalTo(self.viewContainer)
            make.width.height.equalTo(50)
        }
        
        //Position title
        self.viewContainer.addSubview(self.titleLabel)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageViewPlaceholder.snp.right).offset(8)
            make.right.equalTo(self.viewContainer.snp.right).offset(-8)
            make.top.equalTo(self.imageViewPlaceholder)
        }
        
    }
    
    func setupCell(modal: DeliveryModel){
        self.imageViewPlaceholder.sd_setImage(with: URL.init(string: modal.imageURL)) { (image, error, cache, url) in
        }
        self.titleLabel.text = "\(modal.deliveryDescription) at \(modal.address)"
    }

}
