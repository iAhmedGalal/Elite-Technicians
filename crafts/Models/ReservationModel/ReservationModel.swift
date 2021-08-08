//
//  ReservationModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class ReservationModel: NSObject, NSCoding, Mappable {
    var reservation_id: Int?
    var provider_id: Int?
    var address: String?
    var lat: String?
    var lon: String?
    var comment: String?
    var date: String?
    var time: String?
    var coupon_id: Int?
    var coupon_percentage: Int?
    var city_id: String?
    var service_ids: [Int]?
    var service_Prices: [Double]?
    
    var services_total: Double?

    override init() {}
    
    required init?(map: Map) {}
    
    required init(coder decoder: NSCoder) {
        self.reservation_id = decoder.decodeObject(forKey: "reservation_id")  as? Int ?? 0
        self.provider_id = decoder.decodeObject(forKey: "provider_id")  as? Int ?? 0
        self.address = decoder.decodeObject(forKey: "address") as? String ?? ""
        self.lat = decoder.decodeObject(forKey: "lat") as? String ?? ""
        self.lon = decoder.decodeObject(forKey: "lon") as? String ?? ""
        self.comment = decoder.decodeObject(forKey: "comment") as? String ?? ""
        self.date = decoder.decodeObject(forKey: "date") as? String ?? ""
        self.time = decoder.decodeObject(forKey: "time") as? String ?? ""
        self.coupon_id = decoder.decodeObject(forKey: "coupon_id")  as? Int ?? 0
        self.coupon_percentage = decoder.decodeObject(forKey: "coupon_percentage")  as? Int ?? 0
        self.city_id = decoder.decodeObject(forKey: "city_id")  as? String ?? ""
        self.service_ids = decoder.decodeObject(forKey: "service_ids") as? [Int] ?? []
        self.service_Prices = decoder.decodeObject(forKey: "service_Prices") as? [Double] ?? []

        self.services_total = decoder.decodeObject(forKey: "services_total") as? Double ?? 0
    }
    
    func mapping(map: Map) {
        reservation_id <- map["reservation_id"]
        provider_id <- map["provider_id"]
        address <- map["address"]
        lat <- map["lat"]
        lon <- map["lon"]
        comment <- map["comment"]
        date <- map["date"]
        time <- map["time"]
        coupon_id <- map["coupon_id"]
        coupon_percentage <- map["coupon_percentage"]
        city_id <- map["city_id"]
        service_ids <- map["service_ids"]
        service_Prices <- map["service_Prices"]
        services_total <- map["services_total"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(reservation_id ,forKey: "reservation_id")
        coder.encode(provider_id ,forKey: "provider_id")
        coder.encode(address ,forKey: "address")
        coder.encode(lat ,forKey: "lat")
        coder.encode(lon ,forKey: "lon")
        coder.encode(comment ,forKey: "comment")
        coder.encode(date ,forKey: "date")
        coder.encode(time ,forKey: "time")
        coder.encode(coupon_id ,forKey: "coupon_id")
        coder.encode(coupon_percentage ,forKey: "coupon_percentage")
        coder.encode(city_id ,forKey: "city_id")
        coder.encode(service_ids ,forKey: "service_ids")
        coder.encode(service_Prices ,forKey: "service_Prices")
        coder.encode(services_total ,forKey: "services_total")
    }
}
