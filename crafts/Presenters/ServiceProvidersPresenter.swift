//
//  ServiceProvidersPresenter.swift
//  crafts
//
//  Created by AL Badr  on 1/10/21.
//

import UIKit
import Foundation

protocol ServiceProvidersPresenterView: NSObjectProtocol {
    func getProvidersSuccess(_ response: [Providers])
    func getProviderFailure()
    
    func AddToFavouriteSuccess(_ message: String)
    func removeFromFavouriteSuccess(_ message: String)
    func favouriteFailure(_ message: String)

    func showConnectionErrorMessage()
}

class ServiceProvidersPresenter {
    weak fileprivate var providerView: ServiceProvidersPresenterView?
    fileprivate let api = GetInteractors()
    fileprivate let postAPI = PostInteractors()

    init(_ lView: ServiceProvidersPresenterView) {
        providerView = lView
    }
    
    init() {}
    
    func detachView() {
        providerView = nil
    }

    public func getProviders(department_id: String, city_id: String) {
        api.getProviders(department_id: department_id, city_id: city_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.providerView?.getProvidersSuccess(response?.data ?? [])
                }else{
                    self.providerView?.getProviderFailure()
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }
    
    
    public func addToFavourite(parameters: [String : Any]) {
        postAPI.addFavourites(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.providerView?.AddToFavouriteSuccess(response?.message ?? "")
                }else {
                    self.providerView?.favouriteFailure(response?.message ?? "")
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func removeFromFavourite(provider_id: String) {
        postAPI.removeFavourites(provider_id: provider_id) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.providerView?.removeFromFavouriteSuccess(response?.message ?? "")
                }else {
                    self.providerView?.favouriteFailure(response?.message ?? "")
                }
            }else {
                self.providerView?.showConnectionErrorMessage()
            }
        }
    }

}
