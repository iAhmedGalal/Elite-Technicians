//
//  DistrictsModel.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct DistrictsModel : Mappable {
    var id: Int?
    var name_ar: String?
    var name_en: String?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name_ar <- map["name_ar"]
        name_en <- map["name_en"]
    }
}
