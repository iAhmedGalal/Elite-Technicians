//
//  ActivationPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/26/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ActivationPresenterView: NSObjectProtocol {
    func getActivationSuccess(_ message: String)

    func getActivationFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ActivationPresenter {
    weak fileprivate var presenterView: ActivationPresenterView?
    fileprivate let api = AuthInteractors()
    
    init(_ uView: ActivationPresenterView) {
        presenterView = uView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }

    public func checkActivationCode(parameters: [String:Any]) {
        api.activate(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getActivationSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getActivationFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    
}
