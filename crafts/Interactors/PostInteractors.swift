//
//  PostInteractors.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class PostInteractors: NSObject {
    
    var token = (Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel)?.api_token ?? ""
    
    
    func addFavourites(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.ADD_TO_FAVOURITE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url,
                                  withQueryStringParameters: parameters as [String : AnyObject],
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }
    
    func removeFavourites(provider_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.REMOVE_FROM_FAVOURITE, provider_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url,
                                  withQueryStringParameters: nil,
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }
    
    func checkCoupon(parameters: [String : Any] , completion:  @escaping (_ :BaseModel<CouponModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CHECK_COUPON + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<CouponModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    
    func suggestTimes(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.SUGGEST_TIMES + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    
    func savePlaces(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.SAVE_PLACE + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url,
                                  withQueryStringParameters: parameters as [String : AnyObject],
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }
    
    func removePlaces(place_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.REMOVE_PLACE, place_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url,
                                  withQueryStringParameters: nil,
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }
    
    func contactus(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CONTACT_US
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func makeReservation(parameters: [String : Any], completion:  @escaping (_ :BaseModel<ReservationResponse>?,_ :NSError?)->Void) {
        let url = Constants.Urls.RESERVATION + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<ReservationResponse>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
       
    func clientCommentObjection(comment_id: String, parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.OBJECT_COMMENT_CLIENT, comment_id) + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func providerCommentObjection(comment_id: String, parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.OBJECT_COMMENT_PROVIDER, comment_id) + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func payReservation(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.RESERVATION_PAYMENT + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
  
    func readNotification(notification: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.READ_NOTIFICATION + "?api_token=" + token + "&notification=" + notification
        
        ServiceProvider().sendUrl(showActivity: false, method: .post, URLString: url,
                                  withQueryStringParameters: nil,
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }

    func convertToPoints(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CONVERT_TO_POINTS + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }


 
    func getRefund(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.RECOVERY + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func confirmPaymentFromAdmin(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CONFIRM_PAYMENT_ADMIN + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func discountRequest(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.COMMISSION_DISCOUNT_REQUEST + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func payCommission(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.PAID_COMMISSIONS + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientSheet(search: String, page: String, completion:  @escaping (_ :BaseListModel<StatementsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CLIENT_BALANCE  + "?api_token=" + token// + "&search=" + search + "&page=" + page
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<StatementsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderSheet(search: String, page: String, completion:  @escaping (_ :BaseListModel<StatementsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PROVIDER_BALANCE  + "?api_token=" + token + "&search=" + search + "&page=" + page
        
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<StatementsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }

    func removeService(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.REMOVE_SERVICE + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func addOffer(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.ADD_OFFER + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func removeOffer(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.REMOVE_OFFER + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func addService(parameters: [String : Any], image: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.ADD_SERVICE + "?api_token=" + token

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
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< image.count {
                let photo: UIImage = image[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
        
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
    func editService(parameters: [String : Any], image: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.EDIT_SERVICE + "?api_token=" + token

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
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< image.count {
                let photo: UIImage = image[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
        
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func sendBankTransfer(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Constants.Urls.RESERVATION_PAYMENT + "?api_token=" + token
        
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
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            

            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
    func convertToBank(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Constants.Urls.CONVERT_TO_BANK + "?api_token=" + token
        
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
            
            print("url", url)
            print("Headers", Headers)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
        
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func payBankCommission(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        let url =  Constants.Urls.PAY_COMMISSION + "?api_token=" + token
        
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
            
            print("url", url)
            print("parameters", parameters)
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "bank_convert_img", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            

            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    func sendVerificationRequest(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Accept-Language": (LanguageManger.shared.currentLanguage.rawValue as String)]
        
        let url =  Constants.Urls.SEND_VERFiCATION_REQUEST + "?api_token=" + token
        
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
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.5)
                form.append(dataPhoto!, withName: "image_identity", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(PostModel(JSON:response.value as! [String:Any]), nil)
            }
            
        }
    }
    
    func makePublicReservation(parameters: [String : Any], dImage: [UIImage], completion:  @escaping (_ :BaseModel<ReservationResponse>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PUBLIC_RESERVATION + "?api_token=" + token
        
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
            
            for i in 0 ..< dImage.count {
                let photo: UIImage = dImage[i]
                let dataPhoto = photo.jpegData(compressionQuality: 0.8)
                form.append(dataPhoto!, withName: "image", fileName: "uploads.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: url, method: .post, headers: Headers).responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                hud.hide(animated: true)
                print("failure response", error)
                
            case .success(_):
                hud.hide(animated: true)
                let json = JSON(response.value ?? "")
                print("success response", json)
                completion(BaseModel<ReservationResponse>(JSON:response.value as! [String:Any]), nil)
            }
        }
    }
    
    
    /*
     

     
     func getWallet(page: String, completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
         let url = Constants.Urls.SHOW_WALLET  + "?api_token=" + token + "&page=" + page
         
         ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
             
             if error == nil {
                 completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
             }else {
                 completion(nil, error)
             }
         }
     }
     
     func getClientWalletTransactions(completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
         let url = Constants.Urls.CLIENT_WALLET_TRANSACTIONS  + "?api_token=" + token
         
         ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
             
             if error == nil {
                 completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
             }else {
                 completion(nil, error)
             }
         }
     }
     
     func getProviderWalletTransactions(completion:  @escaping (_ :BaseListModel<WalletModel>?,_ :NSError?)->Void) {
         let url = Constants.Urls.PROVIDER_WALLET_TRANSACTIONS  + "?api_token=" + token
         
         ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
             
             if error == nil {
                 completion(BaseListModel<WalletModel>(JSON:response as! [String:Any]), error)
             }else {
                 completion(nil, error)
             }
         }
     }
     
     
     
     
     
     
     */

}
