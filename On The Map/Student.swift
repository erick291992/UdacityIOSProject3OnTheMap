//
//  Student.swift
//  On The Map
//
//  Created by Erick Manrique on 4/22/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

struct Student {
    var createdAt:String
    var firstName:String
    var lastName:String
    var latitude:Double
    var longitude:Double
    var mapString:String
    var mediaURL:String
    var objectId:String
    var uniqueKey:String
    var updatedAt:String
    
//    
//    "createdAt": "2015-02-25T01:10:38.103Z",
//    "firstName": "Jarrod",
//    "lastName": "Parkes",
//    "latitude": 34.7303688,
//    "longitude": -86.5861037,
//    "mapString": "Huntsville, Alabama ",
//    "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
//    "objectId": "JhOtcRkxsh",
//    "uniqueKey": "996618664",
//    "updatedAt": "2015-03-09T22:04:50.315Z"
    init(data: NSDictionary){
        self.createdAt = data["createdAt"] as! String
        self.firstName = data["firstName"] as! String
        self.lastName = data["lastName"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
        self.mapString = data["mapString"] as!String
        self.mediaURL = data["mediaURL"] as!String
        self.objectId = data["objectId"] as!String
        self.uniqueKey = data["uniqueKey"] as!String
        self.updatedAt = data["updatedAt"] as!String
    }
}