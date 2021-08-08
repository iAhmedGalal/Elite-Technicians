//
//  SubDepartmentsModel.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct SubDepartmentsModel : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var name_en : String?
    var image : String?
    var providers_count : Int?
    var price : String?
    var price_after_discount : String?
    var provider_id : Int?
    var department_id : Int?
    var time : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
        name_en <- map["name_en"]
        image <- map["image"]
        price <- map["price"]
        price_after_discount <- map["price_after_discount"]
        provider_id <- map["provider_id"]
        department_id <- map["department_id"]
        time <- map["time"]
        providers_count <- map["providers_count"]
    }
    
}
