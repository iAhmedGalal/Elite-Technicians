//
//  ChangePasswordPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ChangePasswordPresenterView: NSObjectProtocol {
    func getChangePasswordSuccess(_ message: String)

    func getChangePasswordFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ChangePasswordPresenter {
    weak fileprivate var changePasswordView: ChangePasswordPresenterView?
    fileprivate let authAPI = AuthInteractors()
    
    init(_ uView: ChangePasswordPresenterView) {
        changePasswordView = uView
    }
    
    init() {}
    
    func detachView() {
        changePasswordView = nil
    }

    public func ChangePassword(parameters: [String:Any]) {
        authAPI.changePassword(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.changePasswordView?.getChangePasswordSuccess(response?.message ?? "")
                }else{
                    self.changePasswordView?.getChangePasswordFailure(response?.message ?? "")
                }
            }else {
                self.changePasswordView?.showConnectionErrorMessage()
            }
        }
    }

}
