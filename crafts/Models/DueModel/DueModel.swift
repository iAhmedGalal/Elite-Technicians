//
//  DueModel.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct DueModel : Mappable {
    var reservation_id : String?
    var reservation_date : String?
    var reservation_money_required : String?
    var reservation_money_paid : String?
    var reservation_total : String?
    var reservation_add_value : String?
    var reservation_commission_money : String?
    var reservation_rest : String?
    var provider_id : String?
    var required_from_provider : String?
    var payable_to_provider : String?
    var status : String?
    var admin_agree: String?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        reservation_id <- map["reservation_id"]
        reservation_date <- map["reservation_date"]
        reservation_money_required <- map["reservation_money_required"]
        reservation_money_paid <- map["reservation_money_paid"]
        reservation_add_value <- map["reservation_add_value"]
        reservation_commission_money <- map["reservation_commission_money"]
        reservation_rest <- map["reservation_rest"]
        reservation_total <- map["reservation_total"]
        provider_id <- map["provider_id"]
        required_from_provider <- map["required_from_provider"]
        payable_to_provider <- map["payable_to_provider"]
        status <- map["status"]
        admin_agree <- map["admin_agree"]
    }
    
}
