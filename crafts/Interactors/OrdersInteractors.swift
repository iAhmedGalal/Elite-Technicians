//
//  OrdersInteractors.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class OrdersInteractors: NSObject {
    
    var token = (Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel)?.api_token ?? ""
    
    func publicOrders(reservation_id: String, completion:  @escaping (_ :BaseListModel<OrdersModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PUBLIC_ORDERS + "?api_token=" + token  + reservation_id
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<OrdersModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func providerOrders(reservation_id: String, completion:  @escaping (_ :BaseListModel<OrdersModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PROVIDER_ORDERS + "?api_token=" + token  + "&reservation_id=" + reservation_id + "&app_type=ios"
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<OrdersModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func myOrders(reservation_id: String, completion:  @escaping (_ :BaseListModel<OrdersModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CLIENT_ORDERS + "?api_token=" + token  + "&reservation_id=" + reservation_id
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<OrdersModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func myPreviousOrders(reservation_id: String, completion:  @escaping (_ :BaseListModel<OrdersModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.APPLICANTS + "?api_token=" + token  + reservation_id
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<OrdersModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func applyToOrder(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.APPLY_TO_ORDER + "?api_token=" + token
        
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
    
    func removeOrder(reservation_id: String, completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.CANCEL_ORDER, reservation_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url,
                                  withQueryStringParameters: nil,
                                  withHeaders: [:]) { (response, error) in
                                    if error == nil {
                                        completion(PostModel(JSON:response as! [String:Any]), error)
                                    }else {
                                        completion(nil, error)
                                    }
        }
    }
    
    func rateProvider(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.RATE + "?api_token=" + token
        
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
    
    func endReservationClient(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.END_RESERVATION_CLIENT
        
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
    
    func suggestNewTimes(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.SUGGEST_TIMES + "?api_token=" + token
        
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
    
    func submitAnotherDate(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.SUBMIT_NEW_DATE + "?api_token=" + token
        
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
    
    func clientAcceptApplicant(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CLIENT_DECISION + "?api_token=" + token
        
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
    
    func approveOrder(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.APPROVE_ORDER + "?api_token=" + token
        
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
    
    func endCashOrder(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.END_CASH_ORDER + "?api_token=" + token
        
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
    
    func cancelReasons(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.CANCEL_ORDER_PROVIDER + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func makeSatisfied(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.MAKE_SATISFIED + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func managementReport(parameters: [String : Any], completion:  @escaping (_ :PostModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.MANAGEMENT_REPORTING + "?api_token=" + token
        ServiceProvider().sendUrl(showActivity: true, method: .post, URLString: url, withQueryStringParameters: parameters as [String : AnyObject], withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(PostModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
}
