//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Erick Manrique on 4/22/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

extension NetworkClient{
    func getStudentLocations(completionHandlerForLocations:(success:Bool, students:[Student]?, error: NSError?)->Void){
        let requestValues = [Constants.ParseParameterKeys.ApplicationId: Constants.ParseParameterValues.ApplicationId,
                             Constants.ParseParameterKeys.RestAPI: Constants.ParseParameterValues.RestAPI
        ]
        let parameters = ["limit": "100", "order":"-updatedAt"]
        taskForGETMethod("/classes/StudentLocation", parameters: parameters, resquestValues: requestValues, API: Constants.APIValues.Parse) { (result, error) in
            if let error = error {
                completionHandlerForLocations(success: false, students:nil, error: error)
            }
            else{
//                var students = [Student]()
//                if let results = result["results"] as? NSArray{
//                    for value in results{
//                        let data = value as! NSDictionary
//                        let student = Student(data: data)
//                        students.append(student)
//                    }
//                    completionHandlerForLocations(success: true, students: students, error: error)
//                }
                
                if let results = result["results"] as? NSArray{
                    //let students = Student.studentFromResult(results)
                    
                    StudentsArray.studentFromResult(results)
                    
                    //completionHandlerForLocations(success: true, students: students, error: error)
                    completionHandlerForLocations(success: true, students: StudentsArray.students, error: error)
                }
                else{
                    completionHandlerForLocations(success: false, students: nil, error: NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Results Found"]))
                }
            }
        }
    }
    
    func postLocation(student:Student, completionHandlerForPostLocation:(success:Bool, error: NSError?)->Void){
        let requestValues = [Constants.ParseParameterKeys.ApplicationId: Constants.ParseParameterValues.ApplicationId,
                             Constants.ParseParameterKeys.RestAPI: Constants.ParseParameterValues.RestAPI
        ]

        let body = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}"
        taskForPOSTMethod("/classes/StudentLocation", parameters: nil, resquestValues: requestValues, jsonBody: body, API: Constants.APIValues.Parse) { (result, error) in
            if let error = error {
                completionHandlerForPostLocation(success: false, error: error)
            }
            else{
                if let results = result as? NSDictionary{
                    print(results)
                    completionHandlerForPostLocation(success: true, error: error)
                }
                else{
                    completionHandlerForPostLocation(success: false, error: NSError(domain: "postLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Results Found"]))
                }
            }
        }
    }
}