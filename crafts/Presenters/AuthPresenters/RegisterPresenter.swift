//
//  RegisterPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterPresenterView: NSObjectProtocol {
    func getSignupSuccess(_ response: LoginModel)
    func getSignupFailure(_ message: [String])

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

class RegisterPresenter {
    weak fileprivate var SignupView: RegisterPresenterView?
    fileprivate let authAPI = AuthInteractors()
    fileprivate let getAPI = GetInteractors()

    init(_ lView: RegisterPresenterView) {
        SignupView = lView
    }
    
    init() {}
    
    func detachView() {
        SignupView = nil
    }

    public func ClientSignup(parameters: [String:Any]) {
        authAPI.signAsClient(parameters: parameters) { (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.getSignupSuccess(response?.data ?? LoginModel())
                }else {
                    self.SignupView?.getSignupFailure(response?.error ?? [])
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func ProviderSignup(parameters: [String : Any]) {
        authAPI.signAsProvider(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.getSignupSuccess(response?.data ?? LoginModel())
                }else{
                    self.SignupView?.getSignupFailure(response?.error ?? [])
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getCities() {
        getAPI.getCities(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setCities(response?.data ?? [])
                }else{
                    self.SignupView?.setCitiesFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getAreas(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setAreas(response?.data ?? [])
                }else{
                    self.SignupView?.setAreasFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getServiceAreas(city_id: String) {
        getAPI.getDistricts(city_id: city_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setServiceAreas(response?.data ?? [])
                }else{
                    self.SignupView?.setServiceAreasFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getServiceDepartments() {
        getAPI.getDepartments(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.SignupView?.setServicesDepartments(response?.data ?? [])
                }else{
                    self.SignupView?.setServicesDepartmentsFailure()
                }
            }else {
                self.SignupView?.showConnectionErrorMessage()
            }
        }
    }
}
