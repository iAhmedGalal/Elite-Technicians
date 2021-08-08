//
//  FavouritesModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct FavouritesModel : Mappable {
    var imageIdentity : String?
    var bio : String?
    var certified_status : Bool?
    var user_address : String?
    var sub_departments : [SubDepartmentsModel]?
    var rate : Int?
    var discount : String?
    var user_id : Int?
    var user_name : String?
    var cover : String?
    var user_image : String?
    var certifiedFrom : String?
    var certified_image : String?
    var isFav : Bool?
    var verified : Bool?
    var verified_user : Bool?
    var reservations_ended_count : Int?
    var cover_type : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        imageIdentity <- map["imageIdentity"]
        bio <- map["bio"]
        certified_status <- map["certified_status"]
        user_address <- map["user_address"]
        sub_departments <- map["sub_departments"]
        rate <- map["rate"]
        discount <- map["discount"]
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        cover <- map["cover"]
        user_image <- map["user_image"]
        certifiedFrom <- map["certifiedFrom"]
        certified_image <- map["certified_image"]
        isFav <- map["isFav"]
        verified <- map["verified"]
        verified_user <- map["verified_user"]
        reservations_ended_count <- map["reservations_ended_count"]
        cover_type <- map["cover_type"]
    }
}
