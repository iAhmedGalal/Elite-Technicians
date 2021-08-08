//
//  ServiceProvider.swift
//  Intercom
//
//  Created by Zeinab Reda on 3/11/17.
//  Copyright © 2017 Zeinab Reda. All rights reserved.
//

import Alamofire
import MBProgressHUD
import SwiftyJSON

class ServiceProvider {
    
    var selectedLanguage: String = Helper.getCurrentLang()
    
    var Headers : HTTPHeaders = ["Content-Type":"application/json",
                                "Accept":"application/json",
                                "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
    
    func sendUrl(showActivity:Bool,method:HTTPMethod,URLString: String, withQueryStringParameters parameters: [String : AnyObject]?, withHeaders headers: [String : String]?, completionHandler completion:@escaping (_ :NSObject?,_ :NSError?) -> Void)
    {
        
        var hud : MBProgressHUD = MBProgressHUD()
        
        if showActivity
        {
            hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
            
            // Set the custom view mode to show any view.
            
//            let image : UIImage = UIImage(named: "logosmall")!
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            imageView.image = image
//            imageView.contentMode = .scaleAspectFit
//
//            hud.customView = imageView
//            hud.mode = .customView
//            hud.contentColor = UIColor(white: 1, alpha: 0.5)
//            hud.label.text = "جاري التحميل..."
//            hud.label.textColor = UIColor.orange
            
            hud.mode = .indeterminate

        }
        
   
        

        AF.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Headers).responseJSON { (response) in
            debugPrint("Request: \(String(describing: response.request))")
            debugPrint("Headers: \(String(describing: response.request?.allHTTPHeaderFields))")
                        
            print("parameters", JSON(parameters ?? ""))
            
            print("response", JSON(response.value as Any) )
                        
            debugPrint("Error: \(String(describing: response.error))")
            
            hud.show(animated: true)
            
            switch(response.result) {
                
                
            case .success(_):
                
                hud.hide(animated: true)
                
                if response.response?.statusCode == 200 ||  response.response?.statusCode == 201
                {
                    if let data = response.value
                    {
                        completion(data as? NSObject ,nil)
                        
                    }
                }
                    
                    
                else
                {
                    
                    if let data = response.value
                    {
                        completion(data as? NSObject ,nil)
                        
                    }
                    /*
                    print("response", response.result.value as Any)
                    
                    completion(NSObject() ,NSError(domain: "No Internet Connection", code: (response.response?.statusCode)! , userInfo: [:]))
                    
                    //Helper.showFloatAlert(title: "Server Error , please try again later", subTitle: "", type: Constants.AlertType.AlertError)
                    */
 
                    
                }
                
                break
                
            case .failure(_):
                
                hud.hide(animated: true)
                completion(NSObject() ,NSError(domain: "No Internet Connection", code: 0 , userInfo: [:]))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkNetwork"), object: nil ,userInfo: nil)
                break
                
            }
            
        }
        
    }
    
    func sendGetUrl(showActivity:Bool,method:HTTPMethod,URLString: String, withQueryStringParameters parameters: [String : AnyObject]?, withHeaders headers: [String : String]?, completionHandler completion:@escaping (_ :NSObject?,_ :NSError?) -> Void)
    {
        
        var getHud : MBProgressHUD = MBProgressHUD()
        
         if showActivity
         {
            //let image = UIImage.init(named: "logo")
            
            getHud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)

            
//            let image : UIImage = UIImage(named: "logosmall")!
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            imageView.image = image
//            imageView.contentMode = .scaleAspectFit
//
//            getHud.customView = imageView
//            getHud.mode = .customView
//            getHud.contentColor = UIColor(white: 1, alpha: 0.5)
//            getHud.label.text = "جاري التحميل..."
//            getHud.label.textColor = UIColor.orange
            
            getHud.mode = .indeterminate

         }
        
        
        AF.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: Headers).responseJSON { (response) in
            debugPrint("Request: \(String(describing: response.request))")
            debugPrint("Headers: \(String(describing: response.request?.allHTTPHeaderFields))")
                                    
            print("parameters", parameters ?? "")
            
            print("response", JSON(response.value as Any) )
            
            debugPrint("Error: \(String(describing: response.error))")
            
            getHud.show(animated: true)
            
            switch(response.result) {
                
                
            case .success(_):
                getHud.hide(animated: true)
                
                if response.response?.statusCode == 200 ||  response.response?.statusCode == 201
                {
                    if let data = response.value
                    {
                        completion(data as? NSObject ,nil)
                        
                    }
                }
                    
                    
                else
                {
                    
                    if let data = response.value
                    {
                        completion(data as? NSObject ,nil)
                        
                    }
                    /*
                     print("response", response.result.value as Any)
                     
                     completion(NSObject() ,NSError(domain: "No Internet Connection", code: (response.response?.statusCode)! , userInfo: [:]))
                     
                     //Helper.showFloatAlert(title: "Server Error , please try again later", subTitle: "", type: Constants.AlertType.AlertError)
                     */
                    
                    
                }
                
                break
                
            case .failure(_):
                
                getHud.hide(animated: true)
                completion(NSObject() ,NSError(domain: "No Internet Connection", code: 0 , userInfo: [:]))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkNetwork"), object: nil ,userInfo: nil)
                break
                
            }
            
        }
        
    }
    
}
