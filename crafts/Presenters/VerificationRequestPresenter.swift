//
//  VerificationRequestPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/21/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol VerificationRequestPresenterView: NSObjectProtocol {
    func getSendRequestSuccess(_ message: String)
    func getSendRequestFailure(_ message: String)

    func showConnectionErrorMessage()
}

class VerificationRequestPresenter {
    weak fileprivate var requestView: VerificationRequestPresenterView?
    fileprivate let postAPI = PostInteractors()

    
    init(_ lView: VerificationRequestPresenterView) {
        requestView = lView
    }
    
    init() {}
    
    func detachView() {
        requestView = nil
    }
    
    public func VerificationRequest(parameters: [String : Any], imageList: [UIImage]) {
        postAPI.sendVerificationRequest(parameters: parameters, dImage: imageList){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.requestView?.getSendRequestSuccess(response?.message ?? "")
                }else{
                    self.requestView?.getSendRequestFailure(response?.message ?? "")
                }
            }else {
                self.requestView?.showConnectionErrorMessage()
            }
        }
    }
}
