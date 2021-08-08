//
//  SettingsModel.swift
//  salon
//
//  Created by AL Badr  on 6/17/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingsModel : NSObject, NSCoding, Mappable {
    var value_added : String?
    var comission : String?
    var tax_number : String?
    var every_service_money : String?
    
    override init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        value_added <- map["value_added"]
        comission <- map["comission"]
        tax_number <- map["tax_number"]
        every_service_money <- map["every_service_money"]
    }
    
    required init(coder decoder: NSCoder) {
        self.value_added = decoder.decodeObject(forKey: "value_added")  as? String ?? ""
        self.comission = decoder.decodeObject(forKey: "comission") as? String ?? ""
        self.tax_number = decoder.decodeObject(forKey: "tax_number") as? String ?? ""
        self.every_service_money = decoder.decodeObject(forKey: "every_service_money") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(value_added ,forKey: "value_added")
        coder.encode(comission ,forKey: "comission")
        coder.encode(tax_number ,forKey: "tax_number")
        coder.encode(every_service_money ,forKey: "every_service_money")
    }
}
