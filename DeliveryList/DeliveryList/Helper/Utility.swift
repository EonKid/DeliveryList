//
//  Proxy.swift
//  Deloz
//
//  Created by Dhruv on 24/12/16.
//  Copyright © 2015 Dhruv. All rights reserved.
//

import UIKit
import MapKit
import Darwin
import SystemConfiguration.CaptiveNetwork
import GLKit
import PKHUD

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

var KAppDelegate                                    = UIApplication.shared.delegate as! AppDelegate

enum AppInfo {
    static  let  KMode                              = "debug"
    static  let  KAppName                           = "Delivery List"
    static  let  KVersion                           =  "1.0"
    static  let  kModel                             = UIDevice.current.model
    static  let  kSystemVersion                     = UIDevice.current.systemVersion
    static  let  kUserName                          = ""
    static  let  userAgent                          = "\(KMode)"+"/"+"\(KAppName)" + "/" + kModel + "/" + kSystemVersion
}

enum API {
    
    //LocalHost URL
    //static let kBaseURL = "http://localhost:8080"
    
    //Development URL
    static let kBaseURL = "https://mock-api-mobile.dev.lalamove.com"

    //Endpoints
    static let kDeliveryList = "/deliveries"
}

var appColor  = UIColor(red: 52/255, green: 120/255, blue: 205/255, alpha: 1.0)


// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

class Utility: NSObject {
    
    // MARK: - Class Variables
    
    ///singleton object
    static let shared = Utility()
    private override init() { }
    
    //MARK:- Fetch storyboard
    func StoryBoard(strName:String) -> UIStoryboard {
        return UIStoryboard(name: strName, bundle: nil)
    }
    
    func presentingViewController(vc:UIViewController){
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func showActivityIndicator(){
        DispatchQueue.main.async{
                HUD.show(.labeledProgress(title: nil, subtitle: "Please Wait.."))
        }
    }
    
    func hideActivityIndicator(){
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
    
    func validatePhone(phoneNumber: String) -> Bool {
        let PHONE_REGEX                            = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest                              = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result                                 = phoneTest.evaluate(with: phoneNumber)
        return result
    }
    
    func find<T: Equatable>(item: T,inArray:[T])->(Bool,Int){
        for i in 0 ..< inArray.count{
            if item == inArray[i] {
                return (true,i)
            }
        }
        return (false,0)
    }
    
    
    func printJSONDict(dictPayload:NSMutableDictionary){
        var options: JSONSerialization.WritingOptions   = []
        options                                         = JSONSerialization.WritingOptions.prettyPrinted
        do {
            let data = try JSONSerialization.data(withJSONObject: dictPayload, options: options)
            if let string                               = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
            }
        } catch {
            print(error)
        }
    }
    
    func getHeader()->[String:String]{
        let  kHeader = ["Content-Type":"application/json"]
        return kHeader
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func validateUrl (stringURL : NSString) -> Bool {
        let urlRegEx            = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate           = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        return predicate.evaluate(with: stringURL)
    }
    
    
    func flag(_ country:String) -> String {
        let base                : UInt32 = 127397
        var s                   = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat                 = CGFloat(drand48())
        let green:CGFloat               = CGFloat(drand48())
        let blue:CGFloat                = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func convertStringToDate(strDate:String,strFormat:String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat                = strFormat
        formatter.locale                    = Locale(identifier: "en_US")
        return formatter.date(from: strDate)!
    }
    
    func convertDateToString(date:Date,strFormat:String)->String{
        let formatter                       = DateFormatter()
        formatter.dateFormat                = strFormat
        formatter.locale                    = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    
    
    func displayStatusCodeAlert(_ userMessage: String){
        DispatchQueue.main.async {
        UIApplication.shared.keyWindow?.rootViewController?.view.resignFirstResponder()
        }
        UIView.hr_setToastThemeColor(color: appColor)
        KAppDelegate.window!.makeToast(message: userMessage)
    }
    
    //MARK: - Alert Native Dismiss
    func showAlert(_ title: String,message: String)  {
        var alertVc = UIAlertController()
        alertVc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVc, animated: true, completion: {
            let delay = 2.0 * Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)) { () -> Void in
                alertVc.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    // Html Display Alert
    
    func HtmlDisplayStatusAlert(_ userMessage: String){
        var codeErrorAlert = UIAlertController()
        DispatchQueue.main.async{
            Utility.shared.hideActivityIndicator()
            codeErrorAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
            codeErrorAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(codeErrorAlert, animated: true, completion: nil)
        }
    }
    
    //#MARK: - Email Validations
    
    func isValidEmail(_ testStr:String) -> Bool{
        let emailRegEx          = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range               = testStr.range(of: emailRegEx, options:.regularExpression)
        let result              = range != nil ? true : false
        return result
    }
    
    func openSettingApp(){
        var settingAlert = UIAlertController()
        DispatchQueue.main.async{
                Utility.shared.hideActivityIndicator()
                settingAlert = UIAlertController(title: "Connection Problem", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
                settingAlert.addAction(okAction)
                
                let openSetting = UIAlertAction(title:"Settings", style:UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                })
                settingAlert.addAction(openSetting)
                UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
                
        }
    }
   
    
}




