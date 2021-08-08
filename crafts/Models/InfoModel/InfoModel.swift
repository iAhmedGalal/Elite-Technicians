//
//  InfoModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct InfoModel : Mappable {
    var email : String?
    var phone : String?
    var address : String?
    var whatsapp : String?
    var twitter: String?
    var facebook: String?
    var about_ar: String?
    var about_en: String?
    var policy_ar: String?
    var policy_en: String?
    var verification_text_ar: String?
    var verification_text_en: String?
    var wallet_text: String?
    var wallet_text_en: String?
    var snap: String?
    var instagram: String?

    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        email <- map["email"]
        phone <- map["phone"]
        address <- map["address"]
        whatsapp <- map["whatsapp"]
        twitter <- map["twitter"]
        facebook <- map["facebook"]
        about_ar <- map["about_ar"]
        about_en <- map["about_en"]
        policy_ar <- map["policy_ar"]
        policy_en <- map["policy_en"]
        verification_text_ar <- map["verification_text_ar"]
        verification_text_en <- map["verification_text_en"]
        wallet_text <- map["wallet_text"]
        wallet_text_en <- map["wallet_text_en"]
        snap <- map["snap"]
        instagram <- map["instagram"]
    }

}
