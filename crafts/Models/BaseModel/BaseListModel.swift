//
//  BaseListModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseListModel<T>: NSObject, Mappable where T: Mappable {
    var status : Bool?
    var data : [T]?
    var message: String?
    var error: [String]?
    var meta : Meta?
    var links : Links?
    var pointCount: Int?
    var wallet: String?
    var payable: String?
    var payment_required: String?
    var all_balance: String?
    
    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
        message <- map["message"]
        error <- map["error"]
        meta <- map["meta"]
        links <- map["links"]
        pointCount <- map["pointCount"]
        wallet <- map["wallet"]
        payable <- map["payable"]
        payment_required <- map["payment_required"]
        all_balance <- map["all_balance"]
    }
}
