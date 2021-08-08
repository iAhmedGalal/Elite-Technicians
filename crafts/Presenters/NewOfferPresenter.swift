//
//  NewOfferPresenter.swift
//  crafts
//
//  Created by AL Badr  on 1/19/21.
//

import UIKit
import Foundation

protocol NewOfferPresenterView: NSObjectProtocol {
    func getAddOfferSuccess(_ message: String)
    func getAddOfferFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class NewOfferPresenter {
    weak fileprivate var presenterView: NewOfferPresenterView?
    fileprivate let postAPI = PostInteractors()
    
    init(_ lView: NewOfferPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func AddOffer(parameters: [String : Any]) {
        postAPI.addOffer(parameters: parameters){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getAddOfferSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getAddOfferFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
