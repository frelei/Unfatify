//
//  ParseAPI.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

/// ParseAPI handle all the methods available on the framework
class ParseAPI {

    // MARK: CUSTOM TYPES
    typealias PARSE_SUCCESS = (data: AnyObject?) -> Void
    typealias PARSE_ERROR = (error: NSError?) -> Void
    
    // MARK: ATTRIBUTES
    private let PARSE_API_URL = "https://api.parse.com/1/"
    private let APP_ID = "C3yxjFhtMIda9bbWonXBbrnV9MUaGqIeWxpQxw5Q"
    private let APP_KEY = "e7pYgqXvWGuRvfxHeTZtiQNgxxDPB2327PwEsUeg"
    
    private let APP_ID_HEADER = "X-Parse-Application-Id"
    private let APP_KEY_HEADER = "X-Parse-REST-API-Key"
    private let APP_TOKEN_HEADER = "X-Parse-Session-Token"
    
    // MARK: OBJECTS
    
    /**
    Create Object on Parse
        -@Parameter className: Name of the class
        -@Parameter data: The data of the class
        -@Parameter success: Success closure
        -@Paramater failure: Error closure
        -@return: A dictionary with two parameters.
            ```
            {
                "createdAt": "2011-08-20T02:06:57.931Z",
                "objectId": "Ed1nuqPvcm"
            }
            ```
     */
    func createObject(className: String, data:[String:String], success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:String]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    
    // MARK: USERS
    
    /**
    Retrieve users from system
        -@Parameter className: Name of the class
        -@Parameter data: The data of the class
        -@Parameter success: Success closure
        -@Paramater failure: Error closure
        -@return: A dictionary with an array with users
    ```
    {
        "results": [
        {
            "username": "bigglesworth",
            "createdAt": "2011-11-07T20:58:06.445Z",
            "updatedAt": "2011-11-07T20:58:06.445Z",
            "objectId": "3KmCvT7Zsb"
        }, ...
        ]
    }
    ```
    */
    func users(success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]

        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: [:], header: header, success: { (JSON) -> Void in
                let array = JSON as! NSDictionary
                let users = array["results"]
                success(data: users)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    /**
    Login user on the system
        -@Parameter username: username of the user
        -@Parameter password: password of the user
        -@Parameter success: Success closure
        -@Parameter failure: Error closure
        -@return: 
        ```
            {
                "username": "cooldude6",
                "createdAt": "2011-11-07T20:58:34.448Z",
                "updatedAt": "2011-11-07T20:58:34.448Z",
                "objectId": "g7y9tkhB7O",
                "sessionToken": "r:pnktnjyb996sj4p156gjtp4im"
            }
        ```
    */
    func signIn(username: String, password: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
       let urlPath = PARSE_API_URL + "login"
       let webService = WebService()
       let param = ["username":username, "password":password];
       let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
       webService.connection(WebServiceConnectionType.GET, url: urlPath, params: param, header: header,
          success: { (JSON) -> Void in
            let user = JSON as! [String:String]
            success(data: user)
        }, failure: { (ERROR) -> Void in
            failure(error: ERROR)
        })
    }
    /**
    SingUp user on the system
        -@Paramenter param: It's need to hold all the users information. It need contain at least username and password
        -@Parameter success: Success closure
        -@Parameter failure: Error closure
        -@return:
        ```
            {
            "createdAt": "2011-11-07T20:58:34.448Z",
            "objectId": "g7y9tkhB7O",
            "sessionToken": "r:pnktnjyb996sj4p156gjtp4im"
            }
        ```
    */
    func signUp(param:[String:String], success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: param, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:String]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    /**
    Logout user on the system
        -@Parameter username: username of the user
        -@Parameter password: password of the user
        -@Parameter token: token session
    
    */
    func logout(username: String, password: String, token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "login"
        let webService = WebService()
        let param = ["username":username, "password":password];
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: param, header: header,
            success: { (JSON) -> Void in
                success(data: JSON)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    /**
    Retrieve a user associate with that session token
        -@Parameter token: The token of the user
        -@return: A user
    */
    func currentUser(token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users/me"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]
        
        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: [:], header: header,
            success: { (JSON) -> Void in
                let user = JSON as! [String:String]
                success(data: user)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    /**
    Update the user
        -@Parameter data: Dictionary with properties, The user are not able to change your username and password
        -@return 
        ```
            {
                "updatedAt": "2011-11-07T21:25:10.623Z"
            }
        ```
    */
    func updateUser(data:[String:String], userID: String, token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users/" + userID
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]
        
        webService.connection(WebServiceConnectionType.PUT, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let user = JSON as! [String:String]
                success(data: user)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    /**
    Reset password to user
        -@Parameter email: email of the user 
        -@return: empty value
    */
    func resetPassword(email: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "requestPasswordReset"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: [:], header: header,
            success: { (JSON) -> Void in
                let value = JSON as! [String:String]
                success(data: value)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
        
    }
    
    
    
}
