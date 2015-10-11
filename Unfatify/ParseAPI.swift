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

    typealias PARSE_SUCCESS = (data: AnyObject?) -> Void
    typealias PARSE_ERROR = (error: AnyObject?) -> Void
    
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
    func createObject(className: String, data:[String:AnyObject]?, success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Retrieve Object on Parse
    
        -@Parameter className: Name of the class
        -@Parameter success: Success closure
        -@Paramater failure: Error closure
        -@return: object
    */
    func retrieveObject(className: String, objectId: String, success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className + "/" + objectId
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: nil, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Update Object on Parse
    
        -@Parameter className: Name of the class
        -@Parameter success: Success closure
        -@Parameter failure: Error closure
        -@return: return a dicionary with attribute update value
    */
    func updateObject(className: String, objectId: String, data: [String:AnyObject]?, success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className + "/" + objectId
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.PUT, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Delete Object on Parse
    
    -@Parameter className: Name of the class
    -@Parameter success: Success closure
    -@Parameter failure: Error closure
    -@return: return a dicionary with attribute update value
    */
    func deleteObject(className: String, objectId: String, data: [String:AnyObject]?, success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className + "/" + objectId
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.DELETE, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String:AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Query Objects on Parse
    
        -@Parameter className: Name of the class
        -@Parameter success: Success closure
        -@Parameter failure: Error closure
        -@return: Array objects
    */
    func queryObjects(className: String, whereClause: [String:AnyObject]?,  success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: whereClause, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object["results"])
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String:AnyObject]
                failure(error: fail)
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

        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: nil, header: header, success: { (JSON) -> Void in
            let array = JSON as! [String:AnyObject]
                let users = array["results"]
                success(data: users)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
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
       let urlPath = PARSE_API_URL + "login?" + "username=" + username + "&password=" + password
       let webService = WebService()
       let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
       
        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: nil, header: header,
          success: { (JSON) -> Void in
            let user = JSON as! [String:AnyObject]
            success(data: user)
        }, failure: { (ERROR) -> Void in
            let fail = ERROR as! [String: AnyObject]
            failure(error: fail)
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
    func signUp(param:[String:AnyObject], success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: param, header: header,
            success: { (JSON) -> Void in
                let object = JSON as! [String:AnyObject]
                success(data: object)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Logout user on the system
        -@Parameter token: token session
    
    */
    func logout(token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "logout"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: nil, header: header,
            success: { (JSON) -> Void in
                success(data: JSON)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Retrieve a user associate with that session token
    
        -@Parameter token: The token of the user
        -@return:  user
    */
    func currentUser(token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users/me"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]

        let semaphore = dispatch_semaphore_create(0)
        webService.connection(WebServiceConnectionType.GET_SYNC, url: urlPath, params: nil, header: header,
            success: { (JSON) -> Void in
                let json = JSON as! [String: AnyObject]
                dispatch_semaphore_signal(semaphore)
                success(data: json)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                dispatch_semaphore_signal(semaphore)
                failure(error: fail)
        })
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
    func updateUser(data:[String:AnyObject]?, userID: String, token: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users/" + userID
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY, APP_TOKEN_HEADER: token]
        
        webService.connection(WebServiceConnectionType.PUT, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                let user = JSON as! [String:AnyObject]
                success(data: user)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    /**
    Reset password to user
    
        - @Parameter email: email of the user
        - @return: empty value
    */
    func resetPassword(email: String, success: PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "requestPasswordReset"
        let webService = WebService()
        let header = [APP_ID_HEADER : APP_ID, APP_KEY_HEADER : APP_KEY]
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: nil, header: header,
            success: { (JSON) -> Void in
                let value = JSON as! [String:AnyObject]
                success(data: value)
            }, failure: { (ERROR) -> Void in
                let fail = ERROR as! [String: AnyObject]
                failure(error: fail)
        })
    }
    
    
    
}
