//
//  CommentsModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommentsModel : Mappable {
    var rate: String?
    var rate_id: Int?
    var rater_image: String?
    var rate_client: String?
    var rate_provider: String?
    var rate_date: String?
    var comment: String?
    var agree: String?
    var objection: Int?
    var objection_reply: String?
    var reservation_id: String?
    var provider_verification: Bool?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        rate <- map["rate"]
        rate_id <- map["rate_id"]
        rater_image <- map["rater_image"]
        rate_client <- map["rate_client"]
        rate_provider <- map["rate_provider"]
        rate_date <- map["rate_date"]
        comment <- map["comment"]
        agree <- map["agree"]
        objection <- map["objection"]
        objection_reply <- map["objection_reply"]
        reservation_id <- map["reservation_id"]
        provider_verification <- map["provider_verification"]
    }

}
