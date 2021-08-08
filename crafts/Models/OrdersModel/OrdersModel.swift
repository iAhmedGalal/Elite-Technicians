//
//  OrdersModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrdersModel : Mappable {
    var reservation_client_id : String = ""
    var reservation_comment : String = ""
    var reservation_suggest_newTime : [NewDates] = []
    var reservation_addedValue  : Int = 0
    var reservation_paymentType : String = ""
    var reservation_client_image : String = ""
    var reservation_provider_name : String = ""
    var reservation_lat : String = ""
    var reservation_net : String = ""
    var reservation_if_client_end : Bool = false
    var reservation_rest : String = ""
    var reservation_money_pay : String = ""
    var reservation_id : Int = 0
    var reservation_status : String = ""
    var reservation_total : String = ""
    var reservation_client_name : String = ""
    var reservation_date : String = ""
    var reservation_provider_id : String = ""
    var reservation_lon : String = ""
    var reservation_address : String = ""
    var reservation_addValue : String = ""
    var reservation_cancel_reason : String = ""
    var reservation_provider_image : String = ""
    var reservation_details : [Reservation_details] = []
    var reservation_if_provider_end : Bool = false
    var reservation_time : String = ""
    var reservation_if_follow_open: Bool = false
    
    var department_en : String?
    var lat : String?
    var client_name : String?
    var status : String?
    var department_ar : String?
    var id : Int?
    var lon : String?
    var service : String?
    var date : String?
    var time : String?
    var visit_price : String?
    var description : String?
    var address : String?
    var providers: [Providers]?
    
    init?(map: Map) {}
    
    init() {}


    mutating func mapping(map: Map) {
        reservation_client_id <- map["reservation_client_id"]
        reservation_comment <- map["reservation_comment"]
        reservation_suggest_newTime <- map["reservation_suggest_newTime"]
        reservation_addedValue  <- map["reservation_addedValue "]
        reservation_paymentType <- map["reservation_paymentType"]
        reservation_client_image <- map["reservation_client_image"]
        reservation_provider_name <- map["reservation_provider_name"]
        reservation_lat <- map["reservation_lat"]
        reservation_net <- map["reservation_net"]
        reservation_if_client_end <- map["reservation_if_client_end"]
        reservation_rest <- map["reservation_rest"]
        reservation_money_pay <- map["reservation_money_pay"]
        reservation_id <- map["reservation_id"]
        reservation_status <- map["reservation_status"]
        reservation_total <- map["reservation_total"]
        reservation_client_name <- map["reservation_client_name"]
        reservation_date <- map["reservation_date"]
        reservation_provider_id <- map["reservation_provider_id"]
        reservation_lon <- map["reservation_lon"]
        reservation_address <- map["reservation_address"]
        reservation_addValue <- map["reservation_addValue"]
        reservation_cancel_reason <- map["reservation_cancel_reason"]
        reservation_provider_image <- map["reservation_provider_image"]
        reservation_details <- map["reservation_details"]
        reservation_if_provider_end <- map["reservation_if_provider_end"]
        reservation_time <- map["reservation_time"]
        reservation_if_follow_open <- map["reservation_if_follow_open"]
        
        department_en <- map["department_en"]
        lat <- map["lat"]
        client_name <- map["client_name"]
        status <- map["status"]
        department_ar <- map["department_ar"]
        id <- map["id"]
        lon <- map["lon"]
        service <- map["service"]
        date <- map["date"]
        time <- map["time"]
        visit_price <- map["visit_price"]
        description <- map["description"]
        address <- map["address"]
        providers <- map["providers"]
    }

}
