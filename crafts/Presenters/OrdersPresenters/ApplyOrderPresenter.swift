//
//  ApplyOrderPresenter.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import UIKit
import Foundation

protocol ApplyOrderPresenterView : NSObjectProtocol {
    func setApplySuccess(_ message: String)
    func setApplyFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ApplyOrderPresenter {
    weak fileprivate var presenterView : ApplyOrderPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ pView: ApplyOrderPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func applyToOrder(parameters: [String : Any]) {
        api.applyToOrder(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setApplySuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setApplyFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
