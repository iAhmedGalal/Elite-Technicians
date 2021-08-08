//
//  DiscountRequestPresenter.swift
//  salon
//
//  Created by AL Badr  on 10/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol DiscountRequestPresenterView: NSObjectProtocol {
    func getDiscountRequestSuccess(_ message: String)
    func getDiscountRequestFailure(_ message: String)

    func showConnectionErrorMessage()
}

class DiscountRequestPresenter {
    weak fileprivate var presenterView: DiscountRequestPresenterView?
    fileprivate let api = PostInteractors()
    
    init(_ lView: DiscountRequestPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func commessionDiscountRequest(parameters: [String : Any]) {
        api.discountRequest(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getDiscountRequestSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getDiscountRequestFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
}
