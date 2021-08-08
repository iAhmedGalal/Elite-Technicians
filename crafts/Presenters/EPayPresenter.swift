//
//  EPayPresenter.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 14/03/2021.
//

import Foundation
import UIKit

protocol EPayPresenterView: NSObjectProtocol {
    func getPaymentSuccess(_ message: String)
    func getPaymentFailure(_ message: String)

    func showConnectionErrorMessage()
}

class EPayPresenter {
    weak fileprivate var presenterView: EPayPresenterView?
    fileprivate let api = PostInteractors()
    
    init(_ lView: EPayPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }

    public func reservationPayment(parameters: [String : Any], imageList: [UIImage]) {
        api.sendBankTransfer(parameters: parameters, dImage: imageList){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getPaymentSuccess(response?.message ?? "")
                }else{
                    self.presenterView?.getPaymentFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }

}
