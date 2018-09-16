//
//  SpinnerViewTableViewCell.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit

class SpinnerViewTableViewCell: UITableViewCell {

    //MARK: - Variables
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(activityIndicator)
        self.activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
        activityIndicator.hidesWhenStopped = true
        // Start Activity Indicator
        activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
