//
//  AppDelegate.swift
//  On The Map
//
//  Created by Erick Manrique on 4/17/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sharedSession = NSURLSession.sharedSession()
    var sessionID: String? = nil
    var accountKey: Int? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}
extension AppDelegate {
    
    func URLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> NSURL {
        print("loaded appdelegate")
        
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        
        guard let parameters = parameters else{
            print("it is nil")
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
}

