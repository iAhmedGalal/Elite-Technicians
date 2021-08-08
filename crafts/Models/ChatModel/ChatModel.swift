//
//  ChatModel.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct ChatModel : Mappable {
    var status : Bool?
    var chat_data : Chat_data?
    var data : ChatModelData?

    init?(map: Map) {}
    
    init() {}

    mutating func mapping(map: Map) {
        status <- map["status"]
        chat_data <- map["chat_data"]
        data <- map["data"]
    }
    
}
