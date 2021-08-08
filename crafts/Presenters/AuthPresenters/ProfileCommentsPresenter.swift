//
//  ProfileCommentsPresenter.swift
//  salon
//
//  Created by AL Badr  on 7/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ProfileCommentsPresenterView: NSObjectProtocol {
    func getProviderCommentsSuccess(_ response: [CommentsModel])
    func getClientCommentsSuccess(_ response: [CommentsModel])
    
    func getCommentsObjectionSuccess(_ response: String)
    func getCommentsObjectionFailure(_ response: String)

    func getCommentsFailure()
    
    
    func showConnectionErrorMessage()
}

class ProfileCommentsPresenter {
    weak fileprivate var presenterView: ProfileCommentsPresenterView?
    fileprivate let api = GetInteractors()
    fileprivate let postAPI = PostInteractors()

    init(_ lView: ProfileCommentsPresenterView) {
        presenterView = lView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
    
    public func GetProviderComments() {
        api.getProviderComments(){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getProviderCommentsSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.getCommentsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func GetClientComments() {
        api.getClientComments(){ (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getClientCommentsSuccess(response?.data ?? [])
                }else {
                    self.presenterView?.getCommentsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func ObjectionCommentClient(comment_id: String, parameters: [String : Any]) {
        postAPI.clientCommentObjection(comment_id: comment_id, parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getCommentsObjectionSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getCommentsObjectionFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func ObjectionCommentProvider(comment_id: String, parameters: [String : Any]) {
        postAPI.providerCommentObjection(comment_id: comment_id, parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status == true {
                    self.presenterView?.getCommentsObjectionSuccess(response?.message ?? "")
                }else {
                    self.presenterView?.getCommentsObjectionFailure(response?.message ?? "")
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
    
}
