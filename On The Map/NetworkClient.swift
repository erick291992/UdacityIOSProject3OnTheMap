//
//  NetworkClient.swift
//  On The Map
//
//  Created by Erick Manrique on 4/18/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

class NetworkClient{
    
    var accountKey:String?
    var sessionId:String?
    var user:Student?
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject]?,resquestValues:[String:String]? , jsonBody: String, API:Constants.APIValues, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: method, API: API))
        request.HTTPMethod = "POST"
        if let resquestValues = resquestValues{
            for (key, value) in resquestValues {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                print("There was an error with your request")
                sendError(error!.localizedDescription)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                //sendError("Your request returned a status code other than 2xx!")
                //below allow fo us to get the error message we need to diplay based on status code
                let dataArray = NSString(data: data, encoding: NSUTF8StringEncoding)!.componentsSeparatedByString("\"")
                print(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                sendError(dataArray[dataArray.endIndex-2])
                return
            }
            
            switch API {
            case .Parse:
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            case .Udacity:
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            }
            
        }
        task.resume()
        return task
    }
    
    func taskForDELETEMethod(method: String, parameters: [String:AnyObject]?,API: Constants.APIValues, completionHandlerForDELETE: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: method, API: API))
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            guard error == nil else{
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else{
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else{
                sendError("No data was returned by the request!")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        task.resume()
        return task
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, var parameters: [String:AnyObject]?,resquestValues:[String:String]?, API:Constants.APIValues, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: URLFromParameters(parameters, withPathExtension: method, API: API))
        if let resquestValues = resquestValues{
            for (key, value) in resquestValues {
                print("value:\(value)")
                print("key:\(key)")
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard error == nil else{
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let data = data else{
                sendError("No data was returned by the request!")
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else{
                sendError("Your request returned a status code other than 2xx!")
                print(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                return
            }
            
            switch API {
            case .Parse:
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            case .Udacity:
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
            }
            
        }
        task.resume()
        return task
    }
    
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }

    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // create a URL from parameters
    func URLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String? = nil, API:Constants.APIValues) -> NSURL {
        
        let components = NSURLComponents()
        switch API {
        case .Parse:
            components.scheme = Constants.Parse.ApiScheme
            components.host = Constants.Parse.ApiHost
            components.path = Constants.Parse.ApiPath + (withPathExtension ?? "")
        case .Udacity:
            components.scheme = Constants.Udacity.ApiScheme
            components.host = Constants.Udacity.ApiHost
            components.path = Constants.Udacity.ApiPath + (withPathExtension ?? "")

        }
        components.queryItems = [NSURLQueryItem]()
        
        
        guard let parameters = parameters else{
            print(components.URL!)
            return components.URL!
        }
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.URL!)
        return components.URL!
    }
    
    class func sharedInstance() -> NetworkClient {
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        return Singleton.sharedInstance
    }

}