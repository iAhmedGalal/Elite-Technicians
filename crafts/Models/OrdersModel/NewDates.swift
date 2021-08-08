//
//  NewDates.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import ObjectMapper

class NewDates : Mappable {
    var suggest_id  : Int?
    var suggest_time : String = ""
    var suggest_service_id : String?
    var suggest_to : String?
    var suggest_date : String?
    
    var suggestTimeAPI: String = ""
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        suggest_time <- map["suggest_time"]
        suggest_service_id <- map["suggest_service_id"]
        suggest_to <- map["suggest_to"]
        suggest_id  <- map["suggest_id"]
        suggest_date <- map["suggest_date"]
    }
    
    func convertTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        timeFormatter.locale = Locale(identifier: "en_GB")

        print("suggest_time", suggest_time)
    
        let time = timeFormatter.date(from: suggest_time)
        
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "HH:mm:ss"
        newTimeFormatter.locale = Locale(identifier: "en_GB")

        suggestTimeAPI = newTimeFormatter.string(from: time ?? Date())
    }

}
