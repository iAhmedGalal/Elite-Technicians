//
//  AuthInteractors.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//


import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD


class AuthInteractors: NSObject {
    
    var lang = (LanguageManger.shared.currentLanguage.rawValue as String)
    var token = (Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel)?.api_token ?? ""
    
    func login(parameters: [String : Any], completion:  @escaping (_ :BaseModel<LoginModel>?,_ :NSError?)->Void) {
        let url =  Constants.Urls.LOGIN
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters:
                                    parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func signAsClient(parameters: [String : Any], completion:  @escaping (_ :BaseModel<LoginModel>?,_ :NSError?)->Void) {
        let url =  Constants.Urls.CLIENT_REGISTER
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters:
                                    parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func signAsProvider(parameters: [String : Any], completion:  @escaping (_ :BaseModel<LoginModel>?,_ :NSError?)->Void) {
        let url =  Constants.Urls.PROVIDER_REGISTER
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters:
                                    parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func activate(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.ACTIVATE_ACCOUNT
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func sendResetCode(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.FORGET_PASSWORD + "?language=" + lang
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getNewPassword(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.RESET_PASSWORD
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func changePassword(parameters: [String : Any] , completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CHANGE_PASSWORD
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientProfile(completion:  @escaping (_ :BaseModel<LoginModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.EDIT_CLIENT_PROFILE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters:
                                    nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderProfile(completion:  @escaping (_ :BaseModel<LoginModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.EDIT_PROVIDER_PROFILE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters:
                                    nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<LoginModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func updateProfileClient(parameters: [String : Any], profileImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Constants.Urls.UPDATE_CLIENT_PROFILE  + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url: ", url)
            print("parameters", parameters)
            
            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func updateProfileProvider(parameters: [String : Any],
                               profileImage: [UIImage],
                               idImage: [UIImage],
                               serviceImage: [UIImage],
                               districrsIDs: [Int],
                               servicesIDs: [Int],
                               completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Constants.Urls.UPDATE_PROVIDER_PROFILE  + "?api_token=" + token
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        var hud : MBProgressHUD = MBProgressHUD()
        
        hud = MBProgressHUD.showAdded(to: (Helper.getTopViewController()?.view) ?? UIView(), animated: true)
        hud.mode = .indeterminate
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for (key, value) in parameters {
                if value is String || value is Int {
                    form.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            
            print("url: ", url)
            print("parameters", parameters)
            
            for i in 0 ..< profileImage.count {
                let photo: UIImage = profileImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< idImage.count {
                let photo: UIImage = idImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            for i in 0 ..< serviceImage.count {
                let photo: UIImage = serviceImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "cover", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
   
            for i in 0 ..< districrsIDs.count {
                form.append("\(districrsIDs[i])".data(using: .utf8)!, withName: "districts["+"\(i)"+"]")
            }
            
            for i in 0 ..< servicesIDs.count {
                form.append("\(servicesIDs[i])".data(using: .utf8)!, withName: "items["+"\(i)"+"]")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("failure response", json)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
}
