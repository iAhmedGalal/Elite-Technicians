//
//  BankAccountsModel.swift
//  salon
//
//  Created by AL Badr  on 9/27/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct BankAccountsModel : Mappable {
    var id : Int?
    var bank_number : String?
    var bank_name : String?

    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        bank_number <- map["bank_number"]
        bank_name <- map["bank_name"]

    }
}
