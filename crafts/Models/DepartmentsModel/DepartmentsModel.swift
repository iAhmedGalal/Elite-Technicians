//
//  DepartmentsModel.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import Foundation
import ObjectMapper

class DepartmentsModel: NSObject, NSCoding, Mappable {
    var department_id: Int?
    var department_id_String: String?
    var department_name: String?
    var department_name_en: String?
    var department_price: String?
    var description_en: String?
    var description_ar: String?
    var image: String?
    var duration: String?
    var discount: String?
    var afterDiscount: String?
    
    
    override init() {}
    
    required init?(map: Map) {}
    
    required init(coder decoder: NSCoder) {
        self.department_id = decoder.decodeObject(forKey: "department_id")  as? Int ?? 0
        self.department_name = decoder.decodeObject(forKey: "department_name") as? String ?? ""
        self.department_name_en = decoder.decodeObject(forKey: "department_name_en") as? String ?? ""
        self.department_price = decoder.decodeObject(forKey: "department_price") as? String ?? ""
        self.image = decoder.decodeObject(forKey: "image") as? String ?? ""
        self.duration = decoder.decodeObject(forKey: "duration") as? String ?? ""
        self.discount = decoder.decodeObject(forKey: "discount") as? String ?? ""
        self.afterDiscount = decoder.decodeObject(forKey: "afterDiscount") as? String ?? ""
        self.description_en = decoder.decodeObject(forKey: "description_en") as? String ?? ""
        self.description_ar = decoder.decodeObject(forKey: "description_ar") as? String ?? ""
    }
    
    func mapping(map: Map) {
        department_id <- map["department_id"]
        department_id_String <- map ["department_id"]
        department_name <- map["department_name"]
        department_name_en <- map["department_name_en"]
        department_price <- map["department_price"]
        image <- map["image"]
        duration <- map["duration"]
        discount <- map["discount"]
        afterDiscount <- map["afterDiscount"]
        description_en <- map["description_en"]
        description_ar <- map["description_ar"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(department_id ,forKey: "department_id")
        coder.encode(department_name ,forKey: "department_name")
        coder.encode(department_name_en ,forKey: "department_name_en")
        coder.encode(discount ,forKey: "discount")
        coder.encode(department_price ,forKey: "department_price")
        coder.encode(image ,forKey: "image")
        coder.encode(duration ,forKey: "duration")
        coder.encode(afterDiscount ,forKey: "afterDiscount")
        coder.encode(description_en ,forKey: "description_en")
        coder.encode(description_ar ,forKey: "description_ar")
    }
}
