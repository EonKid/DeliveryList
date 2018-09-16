//
//  DeliveryListViewController.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class DeliveryListViewController: UIViewController{
    
    //MARK: - Variables
    var tableViewDelieveryList = UITableView()
    var cellIdentifier = "cellDeliveryList"
    var cellIndentifierIndicator = "cellIndicator"
    var arrDeliveryList = List<DeliveryModel>()
    var deliveryOffset = 0
    var deliveryLimit = 20
    var realm: Realm?
    var isForSpinner = Bool()
    
    //MARK: - ViewController LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.title = "Things to Deliver"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Functions
    
    func initialSetup() {
        //Get stored data from Realm
        self.realm = try! Realm()
        let arrDeliveryResults = self.realm?.objects(DeliveryModel.self)
        if arrDeliveryResults != nil {
            for object in arrDeliveryResults! {
                if let deliveryModel = object as? DeliveryModel{
                    self.arrDeliveryList.append(deliveryModel)
                }
            }
        }
       
        view.addSubview(tableViewDelieveryList)
        tableViewDelieveryList.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableViewDelieveryList.register(DeliveryListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableViewDelieveryList.register(SpinnerViewTableViewCell.self, forCellReuseIdentifier: cellIndentifierIndicator)
        tableViewDelieveryList.dataSource = self
        tableViewDelieveryList.delegate = self
       
        //Get data from webservice
        if self.arrDeliveryList.count == 0{
            let url = API.kBaseURL + API.kDeliveryList + "?offset=\(self.deliveryOffset)&&limit=\(self.deliveryLimit)"
            self.getDeliveryList(url: url, isShowActivityIndicator: true, isPaginated: false)
        }
       
    }
    
    ///Parse delivery data
    func parseDeliveryData(arrData: NSArray)->List<DeliveryModel>{
        let arrDeliveries = List<DeliveryModel>()
         for i in 0 ..< arrData.count {
            if let dictData = arrData.object(at: i) as? NSDictionary{
                let deliveryModel = DeliveryModel()
                if let deliveryId = dictData.object(forKey: "id") as? Int{
                   deliveryModel.deliveryId = deliveryId
                }
                if let deliveryDescription = dictData.object(forKey: "description") as? String{
                    deliveryModel.deliveryDescription = deliveryDescription
                }
                if let imageUrl = dictData.object(forKey: "imageUrl") as? String{
                    deliveryModel.imageURL = imageUrl
                }
                if let dictLocation = dictData.object(forKey: "location") as? NSDictionary{
                    if let latitude = dictLocation.object(forKey: "lat") as? Double{
                        deliveryModel.latitude = latitude
                    }
                    if let longitude = dictLocation.object(forKey: "lng") as? Double{
                        deliveryModel.longitude = longitude
                    }
                    if let address = dictLocation.object(forKey: "address") as? String{
                        deliveryModel.address = address
                    }
                }
                arrDeliveries.append(deliveryModel)
                try! realm?.write {
                    realm?.add(deliveryModel)
                }
    
            }
         }
         return arrDeliveries
    }
    
    //MARK:- Webservice Request
    
    func getDeliveryList(url:String, isShowActivityIndicator:Bool,isPaginated:Bool){
        WebServiceRequest.getData(url: url, isShowActivityIndiCator: isShowActivityIndicator, header: Utility.shared.getHeader() as Dictionary<String, AnyObject>, success: { (arrData) in
            if isPaginated{
                let arrDeliveries = self.parseDeliveryData(arrData: arrData)
                self.arrDeliveryList.append(objectsIn: arrDeliveries)
            }else{
                self.arrDeliveryList = self.parseDeliveryData(arrData: arrData)
            }
            self.isForSpinner = false
              self.tableViewDelieveryList.reloadData()
        }) { (error, errorDict) in
             self.isForSpinner = false
            self.tableViewDelieveryList.reloadData()
        }
    }

}

extension DeliveryListViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isForSpinner  && indexPath.row == self.arrDeliveryList.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifierIndicator, for: indexPath) as! SpinnerViewTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeliveryListTableViewCell
        let deliveryModal = self.arrDeliveryList[indexPath.row]
        cell.setupCell(modal: deliveryModal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForSpinner {
           return self.arrDeliveryList.count + 1
        }
        return self.arrDeliveryList.count
    }
    
}

extension DeliveryListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isForSpinner && indexPath.row == self.arrDeliveryList.count {
            return
        }
         let deliveryListDetails = DeliveryDetailViewController()
        deliveryListDetails.deliveryModal = self.arrDeliveryList[indexPath.row]
         self.navigationController?.pushViewController(deliveryListDetails, animated: true)
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension DeliveryListViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = self.tableViewDelieveryList.indexPathsForVisibleRows?.last
        if indexPath?.row == self.tableViewDelieveryList.numberOfRows(inSection: 0) - 1 && indexPath?.row == self.arrDeliveryList.count - 1 && !isForSpinner && self.tableViewDelieveryList.frame.size.height < self.tableViewDelieveryList.contentSize.height{
            self.isForSpinner = true
            self.tableViewDelieveryList.reloadData()
            self.deliveryOffset = self.arrDeliveryList.count + 1
            let url = API.kBaseURL + API.kDeliveryList + "?offset=\(self.deliveryOffset)&&limit=\(self.deliveryLimit)"
            self.getDeliveryList(url: url, isShowActivityIndicator: false, isPaginated: true)
            
       }
    }
}
