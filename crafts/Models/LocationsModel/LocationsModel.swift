//
//  LocationsModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct LocationsModel : Mappable {
    var place_id : Int?
    var place_title : String?
    var place_lat : String?
    var place_lon : String?
    
    var selected: Bool = false
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        place_id <- map["place_id"]
        place_title <- map["place_title"]
        place_lat <- map["place_lat"]
        place_lon <- map["place_lon"]
    }
}

