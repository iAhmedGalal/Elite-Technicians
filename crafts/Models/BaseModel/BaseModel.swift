//
//  BaseModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import ObjectMapper

class BaseModel<T>: NSObject, Mappable where T: Mappable {
    var status : Bool?
    var data : T?
    var message: String?
    var error: [String]?
    var meta : Meta?
    var links : Links?

    
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
    }
}
