//
//  ContactsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ContactsPresenterView: NSObjectProtocol {
    func setContactsInfoSuccess(_ contacts: InfoModel)

    func setContactUsSuccess(_ message: String)
    func setContactUsFailure(_ message: String)

    
    func showConnectionErrorMessage()
}

class ContactsPresenter {
    weak fileprivate var contactsView : ContactsPresenterView?
    fileprivate let getAPI = GetInteractors()
    fileprivate let postAPI = PostInteractors()
    
    init(_ hView: ContactsPresenterView ){
        contactsView = hView
    }
    
    init() {}
    
    func detachView() {
        contactsView = nil
    }
    
    public func GetContacts() {
        getAPI.siteInfo() { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.contactsView?.setContactsInfoSuccess((response?.data)!)
                }
            }else {
                self.contactsView?.showConnectionErrorMessage()
            }
        }
    }
    

    
    public func SetContactUs(parameters: [String : Any]) {
        postAPI.contactus(parameters: parameters) { (response, error) in
            if error == nil {
                if response?.status ?? false {
                    self.contactsView?.setContactUsSuccess(response?.message ?? "")
                }else {
                    self.contactsView?.setContactUsFailure(response?.message ?? "")
                }
            }else {
                self.contactsView?.showConnectionErrorMessage()
            }
        }
    }
}
