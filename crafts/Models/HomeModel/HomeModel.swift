//
//  HomeModel.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct HomeModel : Mappable {
    var notifications: Int?
    var orders: Int?
    var slider : [Slider]?
    var departments : [DepartmentsModel]?
    var articles : [Articles]?
    var providers : [Providers]?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        notifications <- map["notifications"]
        orders <- map["orders"]
        slider <- map["slider"]
        departments <- map["departments"]
        articles <- map["articles"]
        providers <- map["providers"]
    }
}
