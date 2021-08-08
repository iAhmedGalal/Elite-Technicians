//
//  CancelReasonsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol CancelReasonsPresenterView : NSObjectProtocol {
    func setCancelReasonsSuccess(_ message: String)
    func setCancelReasonsFailure(_ message: String)

    func showConnectionErrorMessage()
}

class CancelReasonsPresenter {
    weak fileprivate var presenterView : CancelReasonsPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ pView: CancelReasonsPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func sendCancelReasons(parameters: [String : Any]) {
        api.cancelReasons(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setCancelReasonsSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setCancelReasonsFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
