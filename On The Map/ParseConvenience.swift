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
                var students = [Student]()
                if let results = result["results"] as? NSArray{
                    for value in results{
                        let data = value as! NSDictionary
                        let student = Student(data: data)
                        students.append(student)
                    }
                    completionHandlerForLocations(success: true, students: students, error: error)
                }
                else{
                    completionHandlerForLocations(success: false, students: nil, error: NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Results Found"]))
                }
            }
        }
    }
}