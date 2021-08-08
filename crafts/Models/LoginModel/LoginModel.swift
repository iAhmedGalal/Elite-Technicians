//
//  LoginModel.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//


import Foundation
import ObjectMapper

class LoginModel: NSObject, NSCoding, Mappable {
    var forget_code : String?
    var block_status : String?
    var cover_type : String?
    var certified_image : String?
    var address : String?
    var type : String?
    var visit : String?
    var verified_user : String?
    var cover : String?
    var provider_discount_percentage : String?
    var email : String?
    var nationality_id : String?
    var name : String?
    var image_identity : String?
    var lon : String?
    var block : String?
    var payment_required : String?
    var active_code : String?
    var lat : String?
    var video : String?
    var identity_id : String?
    var identity_id_Int: Int?
    var point_count : String?
    var last_activity : String?
    var commission_on_rate_id : String?
    var verified : String?
    var place_name : String?
    var logo : String?
    var api_token : String?
    var payable : String?
    var city_id : String?
    var city_id_Int : Int?
    var district_id : String?
    var district_id_Int : Int?
    var active : String?
    var image_url : String?
    var id : Int?
    var phone : String?
    var bio : String?
    var department_id : String?
    var wallet : String?
    var certified_from : String?
    var player_id : String?
    var image : String?
    var online : String?
    var services_info: String?
    var experience: String?
    
    var departments : [DepartmentsModel]?
    var work_areas : [DistrictsModel]?
    
    override init() {}

    required init?(map: Map) {}

    func mapping(map: Map) {
        forget_code <- map["forget_code"]
        block_status <- map["block_status"]
        cover_type <- map["cover_type"]
        certified_image <- map["certified_image"]
        address <- map["address"]
        type <- map["type"]
        visit <- map["visit"]
        verified_user <- map["verified_user"]
        cover <- map["cover"]
        provider_discount_percentage <- map["provider_discount_percentage"]
        email <- map["email"]
        nationality_id <- map["nationality_id"]
        name <- map["name"]
        image_identity <- map["image_identity"]
        lon <- map["lon"]
        block <- map["block"]
        payment_required <- map["payment_required"]
        active_code <- map["active_code"]
        lat <- map["lat"]
        video <- map["video"]
        identity_id <- map["identity_id"]
        identity_id_Int <- map["identity_id"]
        point_count <- map["point_count"]
        last_activity <- map["last_activity"]
        commission_on_rate_id <- map["commission_on_rate_id"]
        verified <- map["verified"]
        place_name <- map["place_name"]
        logo <- map["logo"]
        api_token <- map["api_token"]
        payable <- map["payable"]
        city_id <- map["city_id"]
        city_id_Int <- map["city_id"]
        district_id <- map["district_id"]
        district_id_Int <- map["district_id"]
        active <- map["active"]
        image_url <- map["image_url"]
        id <- map["id"]
        phone <- map["phone"]
        bio <- map["bio"]
        department_id <- map["department_id"]
        wallet <- map["wallet"]
        certified_from <- map["certified_from"]
        player_id <- map["player_id"]
        image <- map["image"]
        online <- map["online"]
        services_info <- map["services_info"]
        experience <- map["experience"]

        departments <- map["departments"]
        work_areas <- map["work_areas"]
    }
    
    required init(coder decoder: NSCoder) {
        self.forget_code = decoder.decodeObject(forKey: "forget_code")  as? String ?? ""
        self.address = decoder.decodeObject(forKey: "address") as? String ?? ""
        self.lat = decoder.decodeObject(forKey: "lat") as? String ?? ""
        self.lon = decoder.decodeObject(forKey: "lon") as? String ?? ""
        self.city_id = decoder.decodeObject(forKey: "city_id")  as? String ?? ""
        self.block_status = decoder.decodeObject(forKey: "block_status") as? String ?? ""
        self.cover_type = decoder.decodeObject(forKey: "cover_type") as? String ?? ""
        self.certified_image = decoder.decodeObject(forKey: "certified_image") as? String ?? ""
        self.type = decoder.decodeObject(forKey: "type")  as? String ?? ""
        self.visit = decoder.decodeObject(forKey: "visit")  as? String ?? ""
        self.verified_user = decoder.decodeObject(forKey: "verified_user") as? String ?? ""
        self.cover = decoder.decodeObject(forKey: "cover") as? String ?? ""
        self.provider_discount_percentage = decoder.decodeObject(forKey: "provider_discount_percentage") as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email")  as? String ?? ""
        self.nationality_id = decoder.decodeObject(forKey: "nationality_id") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.image_identity = decoder.decodeObject(forKey: "image_identity") as? String ?? ""
        self.block = decoder.decodeObject(forKey: "block")  as? String ?? ""
        self.payment_required = decoder.decodeObject(forKey: "payment_required") as? String ?? ""
        self.active_code = decoder.decodeObject(forKey: "active_code") as? String ?? ""
        self.video = decoder.decodeObject(forKey: "video") as? String ?? ""
        self.identity_id = decoder.decodeObject(forKey: "identity_id")  as? String ?? ""
        self.point_count = decoder.decodeObject(forKey: "point_count")  as? String ?? ""
        self.last_activity = decoder.decodeObject(forKey: "last_activity") as? String ?? ""
        self.commission_on_rate_id = decoder.decodeObject(forKey: "commission_on_rate_id") as? String ?? ""
        self.verified = decoder.decodeObject(forKey: "verified") as? String ?? ""
        self.place_name = decoder.decodeObject(forKey: "place_name")  as? String ?? ""
        self.logo = decoder.decodeObject(forKey: "logo") as? String ?? ""
        self.api_token = decoder.decodeObject(forKey: "api_token") as? String ?? ""
        self.payable = decoder.decodeObject(forKey: "payable") as? String ?? ""
        self.active = decoder.decodeObject(forKey: "active")  as? String ?? ""
        self.image_url = decoder.decodeObject(forKey: "image_url") as? String ?? ""
        self.id = decoder.decodeObject(forKey: "id") as? Int ?? 0
        self.phone = decoder.decodeObject(forKey: "phone") as? String ?? ""
        self.district_id = decoder.decodeObject(forKey: "district_id")  as? String ?? ""
        self.bio  = decoder.decodeObject(forKey: "bio") as? String ?? ""
        self.department_id = decoder.decodeObject(forKey: "department_id") as? String ?? ""
        self.wallet = decoder.decodeObject(forKey: "wallet") as? String ?? ""
        self.certified_from = decoder.decodeObject(forKey: "certified_from")  as? String ?? ""
        self.player_id = decoder.decodeObject(forKey: "player_id")  as? String ?? ""
        self.image = decoder.decodeObject(forKey: "image") as? String ?? ""
        self.commission_on_rate_id = decoder.decodeObject(forKey: "commission_on_rate_id") as? String ?? ""
        self.online = decoder.decodeObject(forKey: "online") as? String ?? ""
        
        self.services_info = decoder.decodeObject(forKey: "services_info") as? String? ?? ""
        self.experience = decoder.decodeObject(forKey: "experience") as? String? ?? ""

        self.departments = decoder.decodeObject(forKey: "work_areas") as? [DepartmentsModel]? ?? []
        self.work_areas = decoder.decodeObject(forKey: "work_areas") as? [DistrictsModel]? ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(forget_code ,forKey: "forget_code")
        coder.encode(address ,forKey: "address")
        coder.encode(lat ,forKey: "lat")
        coder.encode(lon ,forKey: "lon")
        coder.encode(city_id ,forKey: "city_id")
        coder.encode(block_status ,forKey: "block_status")
        coder.encode(cover_type ,forKey: "cover_type")
        coder.encode(certified_image ,forKey: "certified_image")
        coder.encode(type ,forKey: "type")
        coder.encode(visit ,forKey: "visit")
        coder.encode(verified_user ,forKey: "verified_user")
        coder.encode(cover ,forKey: "cover")
        coder.encode(provider_discount_percentage ,forKey: "provider_discount_percentage")
        coder.encode(email ,forKey: "email")
        coder.encode(nationality_id ,forKey: "nationality_id")
        coder.encode(name ,forKey: "name")
        coder.encode(image_identity ,forKey: "image_identity")
        coder.encode(block ,forKey: "block")
        coder.encode(payment_required ,forKey: "payment_required")
        coder.encode(active_code ,forKey: "active_code")
        coder.encode(video ,forKey: "video")
        coder.encode(identity_id ,forKey: "identity_id")
        coder.encode(point_count ,forKey: "point_count")
        coder.encode(last_activity ,forKey: "last_activity")
        coder.encode(commission_on_rate_id ,forKey: "commission_on_rate_id")
        coder.encode(verified ,forKey: "verified")
        coder.encode(place_name ,forKey: "place_name")
        coder.encode(logo ,forKey: "logo")
        coder.encode(api_token ,forKey: "api_token")
        coder.encode(payable ,forKey: "payable")
        coder.encode(active ,forKey: "active")
        coder.encode(image_url ,forKey: "image_url")
        coder.encode(id ,forKey: "id")
        coder.encode(phone ,forKey: "phone")
        coder.encode(district_id ,forKey: "district_id")
        coder.encode(bio ,forKey: "bio")
        coder.encode(department_id ,forKey: "department_id")
        coder.encode(wallet ,forKey: "wallet")
        coder.encode(certified_from ,forKey: "certified_from")
        coder.encode(player_id ,forKey: "player_id")
        coder.encode(image ,forKey: "image")
        coder.encode(online ,forKey: "online")
        coder.encode(work_areas ,forKey: "work_areas")
        
        coder.encode(departments ,forKey: "departments")
        coder.encode(services_info ,forKey: "services_info")
        coder.encode(experience ,forKey: "experience")

    }

}
