//
//  ProviderDetailsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProviderDetailsPresenterView: NSObjectProtocol {
    func getProvidersDetailsSuccess(_ response: Providers)
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel])
    
    func AddToFavouriteSuccess(_ message: String)
    func removeFromFavouriteSuccess(_ message: String)
    func favouriteFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ProviderDetailsPresenter {
    weak fileprivate var detailsView: ProviderDetailsPresenterView?
    fileprivate let api = GetInteractors()
    fileprivate let postAPI = PostInteractors()

    init(_ lView: ProviderDetailsPresenterView) {
        detailsView = lView
    }
    
    init() {}
    
    func detachView() {
        detailsView = nil
    }

    public func GetProviderDetails(provider_id: String) {
        api.getProviderDetails(provider_id: provider_id){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.detailsView?.getProvidersDetailsSuccess(response?.data ?? Providers())
                    self.detailsView?.getSubDepartmentsSuccess(response?.data?.services ?? [])
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func addToFavourite(parameters: [String : Any]) {
        postAPI.addFavourites(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.detailsView?.AddToFavouriteSuccess(response?.message ?? "")
                }else {
                    self.detailsView?.favouriteFailure(response?.message ?? "")
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func removeFromFavourite(provider_id: String) {
        postAPI.removeFavourites(provider_id: provider_id) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.detailsView?.removeFromFavouriteSuccess(response?.message ?? "")
                }else {
                    self.detailsView?.favouriteFailure(response?.message ?? "")
                }
            }else {
                self.detailsView?.showConnectionErrorMessage()
            }
        }
    }
    
}
