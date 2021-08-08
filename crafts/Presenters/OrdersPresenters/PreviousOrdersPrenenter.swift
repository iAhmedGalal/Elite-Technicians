//
//  PreviousOrdersPrenenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol PreviousOrdersPresenterView: NSObjectProtocol {
    func getMyOrdersSuccess(_ response: [OrdersModel])
    func getMyOrdersFailure()
    
    func removeOrderSuccess(_ message: String)
    func removeOrderFailure(_ message: String)

    func showConnectionErrorMessage()
}

class PreviousOrdersPresenter {
    weak fileprivate var myOrdersView: PreviousOrdersPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ lView: PreviousOrdersPresenterView) {
        myOrdersView = lView
    }
    
    init() {}
    
    func detachView() {
        myOrdersView = nil
    }
    
    public func getPreviousOrders(reservation_id: String) {
        api.myPreviousOrders(reservation_id: reservation_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.myOrdersView?.getMyOrdersSuccess(response?.data ?? [])
                }else{
                    self.myOrdersView?.getMyOrdersFailure()
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
}
