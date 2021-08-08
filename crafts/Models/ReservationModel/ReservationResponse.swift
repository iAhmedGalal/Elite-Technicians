//
//  ReservationResponse.swift
//  salon
//
//  Created by AL Badr  on 6/24/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReservationResponse : Mappable {
    var reservation_id : Int?
    var message : String?
    var net : Double?
    var net_without_deliver : Double?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        reservation_id <- map["reservation_id"]
        message <- map["message"]
        net <- map["net"]
        net_without_deliver <- map["net_without_deliver"]
    }
}
