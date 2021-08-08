//
//  ArticlesPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ArticlesPresenterView : NSObjectProtocol {
    func setArticlesSuccess(_ response: [Articles])
    func setArticlesFailure()

    func showConnectionErrorMessage()
}

class ArticlesPresenter {
    weak fileprivate var presenterView : ArticlesPresenterView?
    fileprivate let api = GetInteractors()
    
    init(_ pView: ArticlesPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func getArticles() {
//        api.getArticles() { (response, error) in
//            if error == nil {
//                if response?.status ?? false {
//                    self.presenterView?.setArticlesSuccess(response?.data ?? [])
//                }else {
//                    self.presenterView?.setArticlesFailure()
//                }
//            }else {
//                self.presenterView?.showConnectionErrorMessage()
//            }
//        }
    }
}
