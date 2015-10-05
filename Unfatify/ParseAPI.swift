//
//  ParseAPI.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class ParseAPI {

    typealias PARSE_SUCCESS = (data: AnyObject?) -> Void
    typealias PARSE_ERROR = (error: NSError?) -> Void
    
    private let PARSE_API_URL = "https://api.parse.com/1/"
    private let header = ["X-Parse-Application-Id":"C3yxjFhtMIda9bbWonXBbrnV9MUaGqIeWxpQxw5Q",
                          "X-Parse-REST-API-Key":"e7pYgqXvWGuRvfxHeTZtiQNgxxDPB2327PwEsUeg"]
  
    
    // MARK: OBJECTS
    func createObject(className: String, data:[String:String], success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "classes/" + className
        let webService = WebService()
        
        webService.connection(WebServiceConnectionType.POST, url: urlPath, params: data, header: header,
            success: { (JSON) -> Void in
                
            }, failure: { (ERROR) -> Void in
                
        })
    }
    
    
    // MARK: USERS
    
    func users(success:PARSE_SUCCESS, failure: PARSE_ERROR){
        let urlPath = PARSE_API_URL + "users"
        let webService = WebService()
        webService.connection(WebServiceConnectionType.GET, url: urlPath, params: [:], header: self.header, success: { (JSON) -> Void in
                let users = JSON as! NSArray
                success(data: users)
            }, failure: { (ERROR) -> Void in
                failure(error: ERROR)
        })
    }
    
    
    
    // MARK: SESSION
    
    
    // MARK: ROLES
    
}
