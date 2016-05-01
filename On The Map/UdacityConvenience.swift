//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Erick Manrique on 4/18/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

extension NetworkClient{
    
    func loginWithUserInfo(username:String, password:String, completionHandlerForLogin:(success:Bool, error: NSError?)->Void){
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPOSTMethod("/session", parameters: nil, resquestValues: nil, jsonBody: body, API: Constants.APIValues.Udacity) { (result, error) in
            if let error = error {
                completionHandlerForLogin(success: false, error: error)
            } else {
                if let session = result[Constants.UdacityParameterKeys.Session] as? NSDictionary {
                    if let id = session[Constants.UdacityParameterKeys.Id] as? String {
                        self.sessionId = id
                    }
                }
                if let account = result[Constants.UdacityParameterKeys.Account] as? NSDictionary {
                    if let registered = account[Constants.UdacityParameterKeys.Registered] as? Bool where registered == true {
                        if let key = account[Constants.UdacityParameterKeys.Key] as? String{
                            self.accountKey = key
                            completionHandlerForLogin(success: true, error: error)
                        }
                    }
                    else{
                        completionHandlerForLogin(success: false, error: NSError(domain: "loginWithUserInfo", code: 0, userInfo: [NSLocalizedDescriptionKey: "User Not Registered"]))
                    }
                } else {
                    print("could not get account")
                    completionHandlerForLogin(success: false, error: NSError(domain: "loginWithUserInfo", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not Log User In"]))
                }
            }
        }
    }
    
    func logoutUser(completionHandlerForLogout: (success:Bool, error: NSError?)->Void){
        taskForDELETEMethod("/session", parameters: nil, API: Constants.APIValues.Udacity) { (result, error) in
            print(result)
            if let error = error {
                completionHandlerForLogout(success: false, error: error)
            }
            else{
                if let session = result[Constants.UdacityParameterKeys.Session] as? NSDictionary {
                    if let id = session[Constants.UdacityParameterKeys.Id] as? String {
                        completionHandlerForLogout(success: true, error: error)
                    }
                    else{
                        completionHandlerForLogout(success: false, error: NSError(domain: "logoutUser", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get Id"]))
                    }
                }
                else {
                    completionHandlerForLogout(success: false, error: NSError(domain: "logoutUser", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get Session"]))
                }
            }
        }
    }
    
    //4370518683
    
    func getUsersPublicData(key:String, completionHandlerForUserData:(success:Bool, error:NSError?)->Void){
        taskForGETMethod("/users/\(key)", parameters: nil, resquestValues: nil, API: Constants.APIValues.Udacity) { (result, error) in
            if let error = error {
                completionHandlerForUserData(success: false, error: error)
            }
            else{
                if let user = result["user"] as? NSDictionary{
                    NetworkClient.sharedInstance().user = Student(user: user)
                    completionHandlerForUserData(success: true, error: error)
                }
                else{
                    completionHandlerForUserData(success: false, error: NSError(domain: "getUsersPublicData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get user info"]))
                }
            }
        }
    }
}