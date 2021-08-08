//
//  GetInteractors.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import Foundation
import UIKit

class GetInteractors: NSObject {
    var token = (Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel)?.api_token ?? ""
    
    func getSettings(completion:  @escaping (_ :BaseModel<SettingsModel>?,_ :NSError?)->Void) {
        let url = (Constants.Urls.ADDS_SETTING) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<SettingsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getHome(completion:  @escaping (_ :BaseModel<HomeModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.HOME + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<HomeModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getDepartments(completion:  @escaping (_ :BaseListModel<DepartmentsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.DEPARTMENTS
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<DepartmentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getSubDepartments(department_id: String, completion:  @escaping (_ :BaseListModel<SubDepartmentsModel>?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.SUB_DEPARTMENT, department_id)
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<SubDepartmentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getCities(completion:  @escaping (_ :BaseListModel<CitiesModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CITIES
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<CitiesModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getDistricts(city_id: String, completion:  @escaping (_ :BaseListModel<DistrictsModel>?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.DISTRICTS, city_id)
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<DistrictsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviders(department_id: String, city_id: String, completion:  @escaping (_ :BaseListModel<Providers>?,_ :NSError?)->Void) {
        let url = Constants.Urls.SPECIFIC_PROVIDERS + "?api_token=" + token + "&department_id=" + department_id + "&city_id=" + city_id
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<Providers>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderDetails(provider_id: String, completion:  @escaping (_ :BaseModel<Providers>?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.PROVIDER_DETAILS, provider_id) + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseModel<Providers>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getClientComments(completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CLIENT_COMMENTS + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderComments(completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PROVIDER_COMMENTS + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getProviderDetailsComments(provider_id: String, completion:  @escaping (_ :BaseListModel<CommentsModel>?,_ :NSError?)->Void) {
        let url = String(format: Constants.Urls.PROVIDER_DETAILS_COMMENTS, provider_id) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<CommentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func myFavourites(completion:  @escaping (_ :BaseListModel<FavouritesModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.FAVOURITES + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<FavouritesModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func myNotifications(completion:  @escaping (_ :BaseListModel<NotificationsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.NOTIFICATIONS_CALL + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<NotificationsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
        
    func getPlaces(completion:  @escaping (_ :BaseListModel<LocationsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.GET_PLACES  + "?api_token=" + token
        
        ServiceProvider().sendGetUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<LocationsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func siteInfo(completion:  @escaping (_ :BaseModel<InfoModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.CONTACT_INFO
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseModel<InfoModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getPolicy(completion:  @escaping (_ :PolicyModel?,_ :NSError?)->Void) {
        let url = Constants.Urls.POLICY
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(PolicyModel(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func getBankAccounts(completion:  @escaping (_ :BaseListModel<BankAccountsModel>?,_ :NSError?)->Void) {
        let url = (Constants.Urls.accounts) + "?api_token=" + token

        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<BankAccountsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func providerServices(completion:  @escaping (_ :BaseListModel<SubDepartmentsModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.SERVICES + "?api_token=" + token
        
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            if error == nil {
                completion(BaseListModel<SubDepartmentsModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func paidCommission(page: String, completion:  @escaping (_ :BaseListModel<DueModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.PAID_COMMISSIONS   + "?api_token=" + token + "&page=" + page
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<DueModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    func notPaidCommission(page: String, completion:  @escaping (_ :BaseListModel<DueModel>?,_ :NSError?)->Void) {
        let url = Constants.Urls.NOT_PAID_COMMISSIONS  + "?api_token=" + token + "&page=" + page
        ServiceProvider().sendUrl(showActivity: true, method: .get, URLString: url, withQueryStringParameters: nil, withHeaders: [:]) { (response, error) in
            
            if error == nil {
                completion(BaseListModel<DueModel>(JSON:response as! [String:Any]), error)
            }else {
                completion(nil, error)
            }
        }
    }
    
}
