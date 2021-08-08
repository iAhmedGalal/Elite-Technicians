//
//  DateLocationPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol DateLocationPresenterView: NSObjectProtocol {
    func getCouponSuccess(_ response: CouponModel)
    func getCouponFailure(_ response: String)
    
    func getReservationSuccess(_ response: ReservationResponse)
    func getReservationFailure(_ message: String)
    
    func showConnectionErrorMessage()
}

class DateLocationPresenter {
    weak fileprivate var presenterView: DateLocationPresenterView?
    fileprivate let api = PostInteractors()
    
    init(_ lView: DateLocationPresenterView) {
        presenterView = lView
    }
    
    init() {}

    func detachView() {
        presenterView = nil
    }

    public func getCoupon(parameters: [String:Any]) {
        api.checkCoupon(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getCouponSuccess((response?.data)!)
                }else{
                    self.presenterView?.getCouponFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func makeReservation(parameters: [String:Any]) {
        api.makeReservation(parameters: parameters){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.presenterView?.getReservationSuccess(response?.data ?? ReservationResponse())
                }else{
                    self.presenterView?.getReservationFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
}

