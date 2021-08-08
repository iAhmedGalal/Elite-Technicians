//
//  BankTransferPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol BankTransferPresenterView: NSObjectProtocol {
    func getBankAccountsSuccess(_ response: [BankAccountsModel])
    func getBankAccountsFailure()

    func getSendTransferSuccess(_ message: String)
    func getSendTransferFailure(_ message: String)

    func showConnectionErrorMessage()
}

class BankTransferPresenter {
    weak fileprivate var presenterView: BankTransferPresenterView?
    fileprivate let api = PostInteractors()
    fileprivate let getApi = GetInteractors()

    
    init(_ lView: BankTransferPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func BankAccounts() {
        getApi.getBankAccounts(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getBankAccountsSuccess(response?.data ?? [])
                }else{
                    self.presenterView?.getBankAccountsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func BankTransfer(parameters: [String : Any], imageList: [UIImage]) {
        api.sendBankTransfer(parameters: parameters, dImage: imageList){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getSendTransferSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getSendTransferFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func convertToBank(parameters: [String : Any], imageList: [UIImage]) {
        api.convertToBank(parameters: parameters, dImage: imageList){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getSendTransferSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getSendTransferFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
