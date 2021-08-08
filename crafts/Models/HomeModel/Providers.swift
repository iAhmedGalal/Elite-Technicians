/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Providers : Mappable {
    var user_id : Int?
    var user_name : String?
    var user_image : String?
    var cover : String?
    var bio : String?
    var experience : Int?
    var services_info : String?
    var isFav : Bool?
    var rate : Int?
    var done_services : String?
    var services : [SubDepartmentsModel]?
    
    var date : String?
    var status : String?
    var time : String?
    var provider_id : Int?
    var cost : String?
    var name : String?

	init?(map: Map) {}
    
    init() {}

	mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_image <- map["user_image"]
        cover <- map["cover"]
        bio <- map["bio"]
        experience <- map["experience"]
        services_info <- map["services_info"]
        isFav <- map["isFav"]
        rate <- map["rate"]
        done_services <- map["done_services"]
        services <- map["services"]
        
        date <- map["date"]
        status <- map["status"]
        time <- map["time"]
        provider_id <- map["provider_id"]
        cost <- map["cost"]
        name <- map["name"]
	}

}
