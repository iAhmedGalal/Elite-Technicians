//
//  PublicOrderPresenter.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import Foundation
import UIKit

protocol PublicOrderPresenterView: NSObjectProtocol {
    func setCities(_ sections: [CitiesModel])
    func setCitiesFailure()
    
    func setAreas(_ sections: [DistrictsModel])
    func setAreasFailure()
    
    func getDepartmentsSuccess(_ response: [DepartmentsModel])
    func getDepartmentsFailure()

    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel])
    func getSubDepartmentsFailure()
    
    func getCouponSuccess(_ response: CouponModel)
    func getCouponFailure(_ response: String)
    
    func getReservationSuccess(_ response: ReservationResponse)
    func getReservationFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class PublicOrderPresenter {
    weak fileprivate var presenterView: PublicOrderPresenterView?
    fileprivate let api = PostInteractors()
    fileprivate let getAPI = GetInteractors()

    init(_ lView: PublicOrderPresenterView) {
        presenterView = lView
    }
    
    init() {}

    func detachView() {
        presenterView = nil
    }
    
    public func GetMainServices() {
        getAPI.getDepartments(){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getDepartmentsSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.getDepartmentsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func GetSubServices(department_id: String) {
        getAPI.getSubDepartments(department_id: department_id){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getSubDepartmentsSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.getSubDepartmentsFailure()
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
   
    public func getCoupon(parameters: [String:Any]) {
        api.checkCoupon(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getCouponSuccess((response?.data)!)
                }else{
                    self.presenterView?.getCouponFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func makeReservation(parameters: [String:Any], dImage: [UIImage]) {
        api.makePublicReservation(parameters: parameters, dImage: dImage){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getReservationSuccess(response?.data ?? ReservationResponse())
                }else{
                    self.presenterView?.getReservationFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
