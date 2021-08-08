//
//  PayCommissionPresenter.swift
//  salon
//
//  Created by AL Badr  on 10/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation

protocol PayCommissionPresenterView: NSObjectProtocol {
    func getPayCommissionSuccess(_ message: String)
    func getPayCommissionFailure(_ message: String)

    func showConnectionErrorMessage()
}

class PayCommissionPresenter {
    weak fileprivate var presenterView: PayCommissionPresenterView?
    fileprivate let api = PostInteractors()
    
    init(_ lView: PayCommissionPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func payCommission(parameters: [String : Any]) {
        api.payCommission(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPayCommissionSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getPayCommissionFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func payBankCommission(parameters: [String : Any], imageList: [UIImage]) {
        api.payBankCommission(parameters: parameters, dImage: imageList){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPayCommissionSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getPayCommissionFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
}
