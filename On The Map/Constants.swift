//
//  Constants.swift
//  On The Map
//
//  Created by Erick Manrique on 4/17/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    enum APIValues:Int {
        case Udacity, Parse
    }
    
    // MARK: Udacity
    struct Udacity {
        static let ApiScheme = "https"
        //static let ApiHost = "udacity.com"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let SignUp = "https://www.udacity.com/account/auth#!/signup"
        static let ApiKey = "4e8bdccc3bb63cefbec21f936eca5651"
    }
    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Account = "account"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Registered = "registered"
    }
    
    // MARK: Udacity Parameter Values
    struct UdacityParameterValues {
        static let ApiKey = "4e8bdccc3bb63cefbec21f936eca5651"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Users
        static let Users = "/users"
        static let UsersKeyGetPublicData = "/users/{key}"
        
    }
    
    struct Segue {
        static let MapViewController = "MapViewController"
        static let TabBarController = "TabBarController"
    }
    struct Parse {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1"
    }
    struct ParseParameterValues {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    struct ParseParameterKeys {
        static let ApplicationId = "X-Parse-Application-Id"
        static let RestAPI = "X-Parse-REST-API-Key"
    }
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 255.0/255.0, green: 135.0/255.0, blue: 41.0/255, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 225.0/255, green: 135.0/255.0, blue: 41.0/255.0, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let OrangeLightColor = UIColor(red: 247.0/255.0, green:201.0/255.0, blue:155.0/255.0, alpha: 1.0)
        static let BlackColor = UIColor(red: 255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha: 1.0)
        static let OrangeColor = UIColor(red: 255.0/255.0, green: 135.0/255.0, blue: 41.0/255, alpha: 1.0)
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = "keyboardWillShow:"
        static let KeyboardWillHide: Selector = "keyboardWillHide:"
        static let KeyboardDidShow: Selector = "keyboardDidShow:"
        static let KeyboardDidHide: Selector = "keyboardDidHide:"
    }
}