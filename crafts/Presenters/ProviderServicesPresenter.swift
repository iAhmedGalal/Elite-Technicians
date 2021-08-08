//
//  ProviderServicesPresenter.swift
//  crafts
//
//  Created by AL Badr  on 1/18/21.
//

import UIKit
import Foundation

protocol ProviderServicesPresenterView: NSObjectProtocol {
    func getDepartmentsSuccess(_ response: [DepartmentsModel])
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel])
    func getServicesSuccess(_ response: [SubDepartmentsModel])
    
    func getAddServiceSuccess(_ message: String)
    func getEditServiceSuccess(_ message: String)
    func getRemoveServiceSuccess(_ message: String)
    func getRemoveOfferSuccess(_ message: String)

    func getDepartmentsFailure()
    func getSubDepartmentsFailure()
    func getServicesFailure()

    func getAddServiceFailure(_ message: String)
    func getEditServiceFailure(_ message: String)
    func getRemoveServiceFailure(_ message: String)
    func getRemoveOfferFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ProviderServicesPresenter {
    weak fileprivate var presenterView: ProviderServicesPresenterView?
    fileprivate let api = GetInteractors()
    fileprivate let postAPI = PostInteractors()

    init(_ lView: ProviderServicesPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }

    public func GetMainServices() {
        api.getDepartments(){ (response, error) in
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
        api.getSubDepartments(department_id: department_id){ (response, error) in
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
    
    public func getProviderServices() {
        api.providerServices(){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getServicesSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.getServicesFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func AddService(parameters: [String : Any], image: [UIImage]) {
        postAPI.addService(parameters: parameters, image: image){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getAddServiceSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getAddServiceFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func EditService(parameters: [String : Any], image: [UIImage]) {
        postAPI.editService(parameters: parameters, image: image){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getEditServiceSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getEditServiceFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func RemoveService(parameters: [String : Any]) {
        postAPI.removeService(parameters: parameters){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getRemoveServiceSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getRemoveServiceFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func RemoveOffer(parameters: [String : Any]) {
        postAPI.removeOffer(parameters: parameters){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getRemoveOfferSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getRemoveOfferFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
