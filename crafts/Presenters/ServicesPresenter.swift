//
//  ServicesPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ServicesPresenterView: NSObjectProtocol {
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel])


    func showConnectionErrorMessage()
}

class ServicesPresenter {
    weak fileprivate var serviceView: ServicesPresenterView?
    fileprivate let api = GetInteractors()
    
    init(_ lView: ServicesPresenterView) {
        serviceView = lView
    }
    
    init() {}
    
    func detachView() {
        serviceView = nil
    }

    public func GetSubServices(department_id: String) {
        api.getSubDepartments(department_id: department_id){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.serviceView?.getSubDepartmentsSuccess(response?.data ?? [])
                }
            }else {
                self.serviceView?.showConnectionErrorMessage()
            }
        }
    }
    
}
