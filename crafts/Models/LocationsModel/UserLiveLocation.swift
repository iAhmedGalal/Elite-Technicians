//
//  UserLiveLocation.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class UserLiveLocation: NSObject, NSCoding {
    var speed: String = ""
    var providerId: String = ""
    var lat: String = ""
    var lon: String = ""
    
    override init() {}
    
    init(providerId: String, lat: String, lon: String, speed: String) {
        self.providerId = providerId
        self.lat = lat
        self.lon = lon
        self.speed = speed
    }
    
    required init(coder decoder: NSCoder) {
        self.speed = decoder.decodeObject(forKey: "speed")  as? String ?? ""
        self.providerId = decoder.decodeObject(forKey: "providerId") as? String ?? ""
        self.lat = decoder.decodeObject(forKey: "lat") as? String ?? ""
        self.lon = decoder.decodeObject(forKey: "lon") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(speed ,forKey: "speed")
        coder.encode(providerId ,forKey: "providerId")
        coder.encode(lat ,forKey: "lat")
        coder.encode(lon ,forKey: "lon")
    }
}
