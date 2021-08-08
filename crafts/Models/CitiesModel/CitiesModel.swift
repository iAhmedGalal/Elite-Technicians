//
//  CitiesModel.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct CitiesModel : Mappable {
    var city_id: Int?
    var city_name: String?
    var city_name_en: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        city_id <- map["city_id"]
        city_name <- map["city_name"]
        city_name_en <- map["city_name_en"]
    }
}
