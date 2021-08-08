//
//  PlacesPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol PlacesPresenterView: NSObjectProtocol {
    func getPlacesSuccess(_ response: [LocationsModel])
    func getPlacesFailure()
    
    func getAddPlaceSuccess()
    func getAddPlaceFailure()
    
    func getRemovePlaceSuccess()
    func getRemovePlaceFailure()
    
    func showConnectionErrorMessage()
}

class PlacesPresenter {
    weak fileprivate var placesView: PlacesPresenterView?
    fileprivate let getAPI = GetInteractors()
    fileprivate let postAPI = PostInteractors()

    
    init(_ lView: PlacesPresenterView) {
        placesView = lView
    }
    
    init() {}
    
    func detachView() {
        placesView = nil
    }
    
    public func getPlaces() {
        getAPI.getPlaces(){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.placesView?.getPlacesSuccess(response?.data ?? [])
                }else{
                    self.placesView?.getPlacesFailure()
                }
            }else {
                self.placesView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func AddPlace(parameters: [String : Any]) {
        postAPI.savePlaces(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.placesView?.getAddPlaceSuccess()
                }else {
                    self.placesView?.getAddPlaceFailure()
                }
            }else {
                self.placesView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func RemovePlace(place_id: String) {
        postAPI.removePlaces(place_id: place_id){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.placesView?.getRemovePlaceSuccess()
                }else{
                    self.placesView?.getRemovePlaceFailure()
                }
            }else {
                self.placesView?.showConnectionErrorMessage()
            }
        }
    }
}
