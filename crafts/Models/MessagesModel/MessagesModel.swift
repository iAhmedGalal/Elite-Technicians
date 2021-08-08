//
//  MessagesModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper

struct MessagesModel : Mappable {
    var client_image_url : String?
    var last_message_type : String?
    var client_id : String?
    var receiver_read : String?
    var last_message : String?
    var client_name : String?
    var client1_status : String?
    var the_date : String?
    var id : Int?
    var date : String?
    var client2_status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        client_image_url <- map["client_image_url"]
        last_message_type <- map["last_message_type"]
        client_id <- map["client_id"]
        receiver_read <- map["receiver_read"]
        last_message <- map["last_message"]
        client_name <- map["client_name"]
        client1_status <- map["client1_status"]
        the_date <- map["the_date"]
        id <- map["id"]
        date <- map["date"]
        client2_status <- map["client2_status"]
    }

}

