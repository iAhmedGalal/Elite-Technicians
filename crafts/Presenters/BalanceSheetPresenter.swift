//
//  BalanceSheetPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol BalanceSheetPresenterView: NSObjectProtocol {
    func getClientSheetSuccess(_ response: [StatementsModel])
    func getClientSheetFailure()
    
    func getProviderSheetSuccess(_ response: [StatementsModel])
    func getProviderSheetFailure()
    
    func setBalanceSuccess(_ balance: String)

    func setLastPageSuccess(_ lPage: Int)
    
    func showConnectionErrorMessage()
}

class BalanceSheetPresenter {
    weak fileprivate var sheetView: BalanceSheetPresenterView?
    fileprivate let postAPI = PostInteractors()
    
    
    init(_ lView: BalanceSheetPresenterView) {
        sheetView = lView
    }
    
    init() {}
    
    func detachView() {
        sheetView = nil
    }
    
    public func getClientBalace(search: String, page: String) {
        postAPI.getClientSheet(search: search, page: page){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.sheetView?.getClientSheetSuccess(response?.data ?? [])
                    self.sheetView?.setLastPageSuccess(response?.meta?.last_page ?? 0)
                    self.sheetView?.setBalanceSuccess(response?.all_balance ?? "")

                }else{
                    self.sheetView?.getClientSheetFailure()
                }
            }else {
                self.sheetView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func getProviderBalance(search: String, page: String) {
        postAPI.getProviderSheet(search: search, page: page) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.sheetView?.getProviderSheetSuccess(response?.data ?? [])
                    self.sheetView?.setLastPageSuccess(response?.meta?.last_page ?? 0)
                    self.sheetView?.setBalanceSuccess(response?.all_balance ?? "")

                }else {
                    self.sheetView?.getProviderSheetFailure()
                }
            }else {
                self.sheetView?.showConnectionErrorMessage()
            }
        }
    }
}
