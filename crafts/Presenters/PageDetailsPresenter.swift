//
//  PageDetailsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol PageDetailsPresenterView: NSObjectProtocol {
    func getPageContentSuccess(_ content: InfoModel)
    func setPolicySuccess(_ contacts: PolicyModel)

    func getPageDetailsFailure(_ message: String)
    func showConnectionErrorMessage()
}

class PageDetailsPresenter {
    weak fileprivate var pageDetailsView: PageDetailsPresenterView?

    fileprivate let api = GetInteractors()
    
    init(_ lView: PageDetailsPresenterView) {
         pageDetailsView = lView
     }
     
     init() {}
     
     func detachView() {
         pageDetailsView = nil
     }
    
    public func GetPageDetails() {
        api.siteInfo(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.pageDetailsView?.getPageContentSuccess(response?.data ?? InfoModel())
                }else{
                    self.pageDetailsView?.getPageDetailsFailure(response?.message ?? "")
                }
            }else {
                self.pageDetailsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func GetPolicy() {
        api.getPolicy() { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.pageDetailsView?.setPolicySuccess(response ?? PolicyModel())
                }
            }else {
                self.pageDetailsView?.showConnectionErrorMessage()
            }
        }
    }
}
