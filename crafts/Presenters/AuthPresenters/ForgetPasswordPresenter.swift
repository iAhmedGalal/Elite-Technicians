//
//  ForgetPasswordPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ForgetPasswordPresenterView: NSObjectProtocol {
    func getResetPasswordSuccess(_ message: String)

    func getResetPasswordFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ForgetPasswordPresenter {
    weak fileprivate var forgetPasswordView: ForgetPasswordPresenterView?
    fileprivate let authAPI = AuthInteractors()
    
    init(_ uView: ForgetPasswordPresenterView) {
        forgetPasswordView = uView
    }
    
    init() {}
    
    func detachView() {
        forgetPasswordView = nil
    }

    public func SendResetCode(parameters: [String:Any]) {
        authAPI.sendResetCode(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.forgetPasswordView?.getResetPasswordSuccess(response?.message ?? "")
                }else{
                    self.forgetPasswordView?.getResetPasswordFailure(response?.message ?? "")
                }
            }else {
                self.forgetPasswordView?.showConnectionErrorMessage()
            }
        }
    }
    
}
