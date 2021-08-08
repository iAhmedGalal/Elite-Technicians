//
//  LoginPresenter.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol LoginPresenterView: NSObjectProtocol {
    func getLoginSuccess(_ response: LoginModel)

    func getLoginFailure(_ message: String)

    func showConnectionErrorMessage()
}

class LoginPresenter {
    weak fileprivate var loginView: LoginPresenterView?
    fileprivate let authAPI = AuthInteractors()
    
    init(_ lView: LoginPresenterView) {
        loginView = lView
    }
    
    init() {}
    
    func detachView() {
        loginView = nil
    }

    public func Login(parameters: [String:Any]) {
        authAPI.login(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.loginView?.getLoginSuccess(response?.data ?? LoginModel())
                }else{
                    if (response?.error ?? []).isEmpty {
                        self.loginView?.getLoginFailure(response?.message ?? "")
                    }else {
                        self.loginView?.getLoginFailure(response?.error?[0] ?? "")
                    }
                }
            }else {
                self.loginView?.showConnectionErrorMessage()
            }
        }
    }
    
}
