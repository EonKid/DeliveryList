//
//  WebServiceRequest.swift
//  FlyZone
//  Created by Dhruv Singh on 02/08/16.
//  Copyright © 2016 Deloz. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceRequest: NSObject {

    //MARK: - PRINT RESPONSE
    class  func printResponse(responseArray:NSArray) {
        var jsonString : NSString = ""
        do
        {
            let Json = try JSONSerialization.data(withJSONObject:responseArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: Json, encoding: String.Encoding.utf8.rawValue)
            jsonString = string! as NSString
            debugPrint("JSONString Response: ",jsonString)
        }catch let error as NSError{
            debugPrint(error.description)
        }
    }
    
    //MARK:- GET DATA
    class func getData(url urlStr: String,isShowActivityIndiCator:Bool, header:Dictionary<String, AnyObject>? = nil, success: @escaping (_ responseDict: NSArray) -> Void, failure: @escaping (_ error: NSError,_ errorDict: NSDictionary? ) -> Void) {
        debugPrint("URL:",urlStr)
        let reachability = Reachability()
        if  reachability?.isReachable  == true{
            if isShowActivityIndiCator {    Utility.shared.showActivityIndicator() }
            request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default,headers:header as? HTTPHeaders)
                .responseJSON { response in
                    Utility.shared.hideActivityIndicator()
                    if(response.response?.statusCode == 200){
                        if let JSON = response.result.value as? NSArray{
                            self.printResponse(responseArray: JSON)
                                success(JSON)
                        }else{
                            Utility.shared.displayStatusCodeAlert("Error: Unable to get response from server")
                            if let error = response.result.error{
                                failure((error as NSError?)!, nil)
                            }else{
                                let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                failure((error), nil)
                            }
                        }
                    }else {
                        if  response.response?.statusCode == 400
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                        }else if response.response?.statusCode == 401
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let message = messageDict.object(forKey: "message") as? String{
                                    if message.count > 0{
                                        displayStatusCodeAlert(message)
                                    }
                                }
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                        }
                        else if response.response?.statusCode == 404
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let message = messageDict.object(forKey: "message") as? String{
                                    if message.count > 0{
                                        displayStatusCodeAlert(message)
                                    }
                                }
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                        }
                        else if response.response?.statusCode ==  500
                        {
                            let myHTMLString = NSString(data: response.data!, encoding:String.Encoding.utf8.rawValue)
                            Utility.shared.HtmlDisplayStatusAlert(myHTMLString! as String)
                            debugPrint("HTML String: \(myHTMLString! as String)")
                            if let error = response.result.error{
                                failure((error as NSError?)!, nil)
                            }else{
                                let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                failure((error), nil)
                            }
                        }
                        else if response.response?.statusCode == 408
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let message = messageDict.object(forKey: "message") as? String{
                                    if message.count > 0{
                                        displayStatusCodeAlert(message)
                                    }
                                }
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                            
                        }
                        else if (response.result.error as NSError?)?.code == -1001
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let message = messageDict.object(forKey: "message") as? String{
                                    if message.count > 0{
                                        displayStatusCodeAlert(message)
                                    }
                                }
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                        }
                        else if (response.result.error as NSError?)?.code == -1009
                        {
                            if let messageDict = response.result.value as? NSDictionary{
                                if let message = messageDict.object(forKey: "message") as? String{
                                    if message.count > 0{
                                        displayStatusCodeAlert(message)
                                    }
                                }
                                if let error = response.result.error{
                                    failure((error as NSError?)!, messageDict)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), messageDict)
                                }
                            }else{
                                if let error = response.result.error{
                                    failure((error as NSError?)!, nil)
                                }else{
                                    let error = NSError.init(domain: "", code: (response.response?.statusCode)!, userInfo: nil)
                                    failure((error), nil)
                                }
                            }
                        }
                    }
            }
            
        } else {
            Utility.shared.hideActivityIndicator()
            Utility.shared.openSettingApp()
        }
    }
    
    class  func displayStatusCodeAlert(_ userMessage: String){
        Utility.shared.displayStatusCodeAlert(userMessage)
    }
    
    class func clearAllCookies(url:String){
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: URL.init(string: url)!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
    }
    
}

