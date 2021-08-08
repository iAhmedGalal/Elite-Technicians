//
//  StatementsModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper

struct StatementsModel : Mappable {
    var reservation_provider_money : String?
    var reservation_every_service_money : String?
    var reservation_commission : String?
    var reservation_details : [Reservation_details]?
    var reservation_commission_agreement : String?
    var reservation_add_value : String?
    var reservation_payment_way : String?
    var reservation_coupon_percentage : Int?
    var reservation_rest : String?
    var reservation_total : String?
    var reservation_client_name : String?
    var reservation_net : String?
    var reservation_id : Int?
    var reservation_money_pay : String?
    var reservation_date : String?
    var reservation_payment_way_en: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        reservation_provider_money <- map["reservation_provider_money"]
        reservation_every_service_money <- map["reservation_every_service_money"]
        reservation_commission <- map["reservation_commission"]
        reservation_details <- map["reservation_details"]
        reservation_commission_agreement <- map["reservation_commission_agreement"]
        reservation_add_value <- map["reservation_add_value"]
        reservation_payment_way <- map["reservation_payment_way"]
        reservation_coupon_percentage <- map["reservation_coupon_percentage"]
        reservation_rest <- map["reservation_rest"]
        reservation_total <- map["reservation_total"]
        reservation_client_name <- map["reservation_client_name"]
        reservation_net <- map["reservation_net"]
        reservation_id <- map["reservation_id"]
        reservation_money_pay <- map["reservation_money_pay"]
        reservation_date <- map["reservation_date"]
        reservation_payment_way_en <- map["reservation_payment_way_en"]
    }
}

