//
//  EditProfilePresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfilePresenterView: NSObjectProtocol {
    func getProviderDataSuccess(_ response: LoginModel)
    func getClientDataSuccess(_ response: LoginModel)

    func getUpdateProfileSuccess(_ response: PostModel)
    func getUpdateProfileFailure(_ message: String)

    func setCities(_ sections: [CitiesModel])
    func setCitiesFailure()
    
    func setAreas(_ sections: [DistrictsModel])
    func setAreasFailure()
    
    func setServiceAreas(_ sections: [DistrictsModel])
    func setServiceAreasFailure()
    
    func setServicesDepartments(_ sections: [DepartmentsModel])
    func setServicesDepartmentsFailure()

    func showConnectionErrorMessage()
}

class EditProfilePresenter {
    weak fileprivate var presenterView: EditProfilePresenterView?
    fileprivate let authAPI = AuthInteractors()
    fileprivate let getAPI = GetInteractors()

    init(_ lView: EditProfilePresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func getClientData() {
        authAPI.getClientProfile() { (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getClientDataSuccess(response?.data ?? LoginModel())
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getProviderData() {
        authAPI.getProviderProfile() { (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getProviderDataSuccess(response?.data ?? LoginModel())
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func updateClient(parameters: [String:Any], profile: [UIImage]) {
        authAPI.updateProfileClient(parameters: parameters, profileImage: profile) { (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getUpdateProfileSuccess(response ?? PostModel())
                }else {
                    let error = response?.error ?? []
                    if error.isEmpty {
                        self.presenterView?.getUpdateProfileFailure(response?.message ?? "")
                    }else {
                        self.presenterView?.getUpdateProfileFailure(error[0])
                    }
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func updateProvider(parameters: [String : Any],
                               profileImage: [UIImage],
                               idImage: [UIImage],
                               serviceImage: [UIImage],
                               districrsIDs: [Int],
                               servicesIDs: [Int]) {
        
        authAPI.updateProfileProvider(parameters: parameters,
                               profileImage: profileImage,
                               idImage: idImage,
                               serviceImage: serviceImage,
                               districrsIDs: districrsIDs,
                               servicesIDs: servicesIDs){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getUpdateProfileSuccess(response ?? PostModel())
                }else{
                    let error = response?.error ?? []
                    if error.isEmpty {
                        self.presenterView?.getUpdateProfileFailure(response?.message ?? "")
                    }else {
                        self.presenterView?.getUpdateProfileFailure(error[0])
                    }
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getCities() {
        getAPI.getCities(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.setCities(response?.data ?? [])
                }else{
                    self.presenterView?.setCitiesFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getAreas(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.setAreas(response?.data ?? [])
                }else{
                    self.presenterView?.setAreasFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getServiceAreas(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.setServiceAreas(response?.data ?? [])
                }else{
                    self.presenterView?.setServiceAreasFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getServiceDepartments() {
        getAPI.getDepartments(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.setServicesDepartments(response?.data ?? [])
                }else{
                    self.presenterView?.setServicesDepartmentsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
