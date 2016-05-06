//
//  StudentsArray.swift
//  On The Map
//
//  Created by Erick Manrique on 5/6/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

struct StudentsArray {
    
    static var students = [Student]()
    
    static func studentFromResult(results: NSArray){
        for value in results{
            let data = value as! NSDictionary
            let student = Student(data: data)
            students.append(student)
        }
    }
}