//
//  ShowRejectionPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ShowRejectionPresenterView : NSObjectProtocol {
    func setSatisfiedSuccess(_ message: String)
    func setSatisfiedFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ShowRejectionPresenter {
    weak fileprivate var presenterView : ShowRejectionPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ pView: ShowRejectionPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func makeSatisfied(parameters: [String : Any]) {
        api.makeSatisfied(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setSatisfiedSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setSatisfiedFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
