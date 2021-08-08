//
//  CurrentOrdersPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import UIKit

protocol CurrentOrdersPresenterView: NSObjectProtocol {
    func getOrdersSuccess(_ response: [OrdersModel])
    func getOrdersFailure()
    
    func removeOrderSuccess(_ message: String)
    func removeOrderFailure(_ message: String)
    
    func getApproveOrderSuccess(_ message: String)
    func getApproveOrderFailure(_ message: String)
    
    func getApplyOrderSuccess(_ message: String)
    func getApplyOrderFailure(_ message: String)
    
    func setCashSuccess(_ message: String)
    func setCashFailure(_ message: String)
        
    func showConnectionErrorMessage()
}

class CurrentOrdersPresenter {
    weak fileprivate var myOrdersView: CurrentOrdersPresenterView?
    fileprivate let api = OrdersInteractors()

    init(_ lView: CurrentOrdersPresenterView) {
        myOrdersView = lView
    }
    
    init() {}
    
    func detachView() {
        myOrdersView = nil
    }
    
    public func getPublicOrders(reservation_id: String) {
        api.publicOrders(reservation_id: reservation_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getOrdersSuccess(response?.data ?? [])
                }else{
                    self.myOrdersView?.getOrdersFailure()
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getProviderOrders(reservation_id: String) {
        api.providerOrders(reservation_id: reservation_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getOrdersSuccess((response?.data)!)
                }else{
                    self.myOrdersView?.getOrdersFailure()
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getClientOrders(reservation_id: String) {
        api.myOrders(reservation_id: reservation_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getOrdersSuccess(response?.data ?? [])
                }else{
                    self.myOrdersView?.getOrdersFailure()
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func deleteOrder(reservation_id: String) {
        api.removeOrder(reservation_id: reservation_id) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.myOrdersView?.removeOrderSuccess(response?.message ?? "")
                }else {
                    self.myOrdersView?.removeOrderFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func approveOrder(parameters: [String : Any]) {
        api.approveOrder(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getApproveOrderSuccess(response?.message ?? "")
                }else{
                    self.myOrdersView?.getApproveOrderFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func endCashOrder(parameters: [String : Any]) {
        api.endCashOrder(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.myOrdersView?.setCashSuccess(response?.message ?? "")
                }else {
                    self.myOrdersView?.setCashFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func applyOrder(parameters: [String : Any]) {
        api.applyToOrder(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.myOrdersView?.getApplyOrderSuccess(response?.message ?? "")
                }else {
                    self.myOrdersView?.getApplyOrderFailure(response?.message ?? "")
                }
            }else {
                self.myOrdersView?.showConnectionErrorMessage()
            }
        }
    }
 
    
}
