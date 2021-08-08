//
//  ChatPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

protocol ChatPresenterView: NSObjectProtocol {
    func getChatSuccess(_ response: ChatModel)
    func getSendMessageSuccess()

    func noMessages()

    func showConnectionErrorMessage()
}

class ChatPresenter {
    weak fileprivate var chatView: ChatPresenterView?
    fileprivate let chatAPI = ChatInteractors()


    init(_ lView: ChatPresenterView) {
        chatView = lView
    }
    
    init() {}
    
    func detachView() {
        chatView = nil
    }
    
    public func getChat(clientId: String) {
        chatAPI.getChatMessages(client_id: clientId){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.chatView?.getChatSuccess(response ?? ChatModel())
                }else{
                    self.chatView?.noMessages()
                }
            }else {
                self.chatView?.showConnectionErrorMessage()
            }
        }
    }
    
    public func openChat(channelId: String) {
        chatAPI.openChat(channel_id: channelId){ (response, error) in
            if error == nil {
                if(response?.status == true){
                }else{
                }
            }else {
                self.chatView?.showConnectionErrorMessage()
            }
        }
    }

    public func sendChatMessage(clientId: String, parameters: [String:Any], images: [UIImage]) {
        chatAPI.sendChatMessage(client_id: clientId, parameters: parameters, dImage: images){ (response, error) in
            if error == nil {
                if(response?.status == true){
                    self.chatView?.getSendMessageSuccess()
                }else{
                }
            }else {
                self.chatView?.showConnectionErrorMessage()
            }
        }
    }
}
