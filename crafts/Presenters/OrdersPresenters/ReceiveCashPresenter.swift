//
//  ReceiveCashPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ReceiveCashPresenterView : NSObjectProtocol {
    func setCashSuccess(_ message: String)
    func setCashFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ReceiveCashPresenter {
    weak fileprivate var presenterView : ReceiveCashPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ pView: ReceiveCashPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func endCashOrder(parameters: [String : Any]) {
        api.endCashOrder(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setCashSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setCashFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
