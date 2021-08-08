//
//  ApplicantsToOrderPresenter.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 22/02/2021.
//

import UIKit
import Foundation

protocol ApplicantsToOrderPresenterView : NSObjectProtocol {
    func setClentDecisionSuccess(_ message: String)
    func setClentDecisionFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class ApplicantsToOrderPresenter {
    weak fileprivate var presenterView : ApplicantsToOrderPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ pView: ApplicantsToOrderPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func agreeToApplicant(parameters: [String : Any]) {
        api.clientAcceptApplicant(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setClentDecisionSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.setClentDecisionFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
