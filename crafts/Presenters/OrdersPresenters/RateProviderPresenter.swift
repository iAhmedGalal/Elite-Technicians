//
//  RateProviderPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/21/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol RateProviderPresenterView: NSObjectProtocol {
    func setRateProviderSuccess(_ message: String)
    func setRateProviderFailure(_ message: String)
    
    func getEndClientReservationSuccess(_ message: String)
    func getEndClientReservationFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class RateProviderPresenter {
    weak fileprivate var rateView : RateProviderPresenterView?
    fileprivate let api = OrdersInteractors()
    
    init(_ hView: RateProviderPresenterView){
        rateView = hView
    }
    
    init() {}
    
    func detachView() {
        rateView = nil
    }
    
    public func RateProvider(parameters: [String : Any]) {
        api.rateProvider(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.rateView?.setRateProviderSuccess(response?.message ?? "")
                }else {
                    self.rateView?.setRateProviderFailure(response?.message ?? "")
                }
            }else {
                self.rateView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func endClientReservation(parameters: [String : Any]) {
        api.endReservationClient(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.rateView?.getEndClientReservationSuccess(response?.message ?? "")
                }else{
                    self.rateView?.getEndClientReservationFailure(response?.message ?? "")
                }
            }else {
                self.rateView?.showConnectionErrorMessage()
            }
        }
    }
}
