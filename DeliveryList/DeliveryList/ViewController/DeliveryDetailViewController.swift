//
//  DeliveryDetailViewController.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import SDWebImage
import RealmSwift

class DeliveryDetailViewController: UIViewController {
    
    //MARK:- Variables
    let mapView = MKMapView()
    let viewContainer = UIView()
    let imageViewPlaceholder = UIImageView()
    let titleLabel = UILabel()
    var deliveryModal = DeliveryModel()

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Delivery Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    
    func initialSetup(){
        self.title = "Delivery Details"
        self.view.backgroundColor = UIColor.white
        //Position mapView
         self.view.addSubview(self.mapView)
         self.mapView.showsUserLocation = true
         self.mapView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.bounds.size.height-100)
            make.top.left.right.equalTo(self.view)

        }
        
        //Position viewContainer
        self.view.addSubview(viewContainer)
        self.viewContainer.backgroundColor = UIColor.white
        self.viewContainer.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(8)
            make.right.equalTo(self.view).offset(-16)
            make.bottom.equalTo(self.view)
            make.height.equalTo(100)
        }

        //Position placeholder view
        self.viewContainer.addSubview(self.imageViewPlaceholder)
        self.imageViewPlaceholder.backgroundColor = UIColor.groupTableViewBackground
        self.imageViewPlaceholder.layer.cornerRadius = 8.0
        self.imageViewPlaceholder.contentMode = .scaleAspectFill
        self.imageViewPlaceholder.clipsToBounds = true
        self.imageViewPlaceholder.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.viewContainer).offset(8)
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
        titleLabel.text = "\(deliveryModal.deliveryDescription) at \(deliveryModal.address)"
        self.imageViewPlaceholder.sd_setImage(with: URL.init(string: deliveryModal.imageURL)) { (image, error, cache, url) in
        }
        
        let span = MKCoordinateSpanMake(0.025, 0.025)
        let deliveryLocation = CLLocationCoordinate2DMake(CLLocationDegrees(deliveryModal.latitude), CLLocationDegrees(deliveryModal.longitude))
        let region = MKCoordinateRegion(center: deliveryLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = false
        mapView.delegate = self
        let userAnnotation = DeliveryAnnotation.init(coordiante: deliveryLocation, title: self.deliveryModal.address as NSString)
        self.mapView.addAnnotation(userAnnotation)
        
    }
 

}

extension DeliveryDetailViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation.isKind(of: MKUserLocation.self)) {
            return nil
        }
        if annotation.isKind(of: DeliveryAnnotation.self) {
            let  annotationView = MKAnnotationView()
            let imgView = UIImageView()
            imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            imgView.image =  #imageLiteral(resourceName: "placeholder")
            let altitudeVw = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            altitudeVw.backgroundColor = UIColor.clear
            annotationView.frame =  CGRect(x: 0, y: 0, width: 30, height: 30)
            altitudeVw.addSubview(imgView)
            annotationView.addSubview(altitudeVw)
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
}
