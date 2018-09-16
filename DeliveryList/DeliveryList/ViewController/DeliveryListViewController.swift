//
//  DeliveryListViewController.swift
//  DeliveryList
//
//  Created by Dhruv Singh on 9/16/18.
//  Copyright © 2018 Dhruv Singh. All rights reserved.
//

import UIKit
import SnapKit

class DeliveryListViewController: UIViewController{
    
    //MARK: - Variables
    var tableViewDelieveryList = UITableView()
    var cellIdentifier = "cellDeliveryList"
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
        self.title = "Delivery List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Functions
    
    func initialSetup() {
        view.addSubview(tableViewDelieveryList)
        tableViewDelieveryList.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableViewDelieveryList.register(DeliveryListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableViewDelieveryList.separatorStyle = .none
        tableViewDelieveryList.dataSource = self
        tableViewDelieveryList.delegate = self
    }
    
    
    //MARK:- Webservice Request

}

extension DeliveryListViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeliveryListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
}

extension DeliveryListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
