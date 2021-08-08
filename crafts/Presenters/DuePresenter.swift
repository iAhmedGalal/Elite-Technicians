//
//  DuePresenter.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol DuePresenterView : NSObjectProtocol {
    func setPaidCommissionSuccess(_ response: [DueModel])
    func setNotPaidCommissionSuccess(_ response: [DueModel])
 
    func setLastPageSuccess(_ lPage: Int)

    func setDueFailure()
    
    func showConnectionErrorMessage()
}

class DuePresenter {
    weak fileprivate var presenterView : DuePresenterView?
    fileprivate let api = GetInteractors()
    
    init(_ pView: DuePresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func paidCommission(page: String) {
        api.paidCommission(page: page) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setLastPageSuccess(response?.meta?.last_page ?? 1)
                    self.presenterView?.setPaidCommissionSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setDueFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func notPaidCommission(page: String) {
        api.notPaidCommission(page: page) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setLastPageSuccess(response?.meta?.last_page ?? 1)
                    self.presenterView?.setNotPaidCommissionSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.setDueFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
