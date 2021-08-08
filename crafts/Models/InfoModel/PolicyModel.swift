//
//  PolicyModel.swift
//  salon
//
//  Created by AL Badr  on 11/5/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct PolicyModel : Mappable {
    var status : Bool?
    var data_ar : String?
    var data_en : String?


    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        data_ar <- map["data_ar"]
        data_en <- map["data_en"]
    }

}
