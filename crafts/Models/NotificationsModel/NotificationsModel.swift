//
//  NotificationsModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct NotificationsModel : Mappable {
    var type : String?
    var message : String?
    var read : Bool?
    var id : String?
    var name : Int?
    var time : String?
    var api_link : String?
    var date : String?
    var message_en: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        type <- map["type"]
        message <- map["message"]
        read <- map["read"]
        id <- map["id"]
        name <- map["name"]
        time <- map["time"]
        api_link <- map["api_link"]
        date <- map["date"]
        message_en <- map["message_en"]
    }

}
