//
//  Student.swift
//  On The Map
//
//  Created by Erick Manrique on 4/22/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

struct Student {
    var createdAt:String?
    var firstName:String?
    var lastName:String?
    var latitude:Double?
    var longitude:Double?
    var mapString:String?
    var mediaURL:String?
    var objectId:String?
    var uniqueKey:String?
    var updatedAt:String?
    
    init(data: NSDictionary){
        self.createdAt = data["createdAt"] as? String
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.latitude = data["latitude"] as? Double
        self.longitude = data["longitude"] as? Double
        self.mapString = data["mapString"] as? String
        self.mediaURL = data["mediaURL"] as? String
        self.objectId = data["objectId"] as? String
        self.uniqueKey = data["uniqueKey"] as? String
        self.updatedAt = data["updatedAt"] as? String
    }
    init(user:NSDictionary){
        self.firstName = user["first_name"] as? String
        self.lastName = user["last_name"] as? String
        self.uniqueKey = user["key"] as? String
    }
    static func studentFromResult(results: [[String: AnyObject]]) -> [Student]{
        var students = [Student]()
        
        for result in results {
            students.append(Student(data: result))
        }
        
        return students
    }
}