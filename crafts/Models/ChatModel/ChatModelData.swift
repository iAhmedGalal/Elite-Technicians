/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ChatModelData : Mappable {
	var path : String?
	var to : Int?
	var current_page : Int?
	var first_page_url : String?
	var data : [ChatMessageModel]?
	var next_page_url : String?
	var prev_page_url : String?
	var total : Int?
	var last_page : Int?
	var from : Int?
	var last_page_url : String?
	var per_page : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		path <- map["path"]
		to <- map["to"]
		current_page <- map["current_page"]
		first_page_url <- map["first_page_url"]
		data <- map["data"]
		next_page_url <- map["next_page_url"]
		prev_page_url <- map["prev_page_url"]
		total <- map["total"]
		last_page <- map["last_page"]
		from <- map["from"]
		last_page_url <- map["last_page_url"]
		per_page <- map["per_page"]
	}

}
