//
//  User.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class User {

    
    var username:String?
    var password:String?
    var picture:String?
    var dailyCalorie: Int?
    
    init(username: String, password: String, picture: String, dailyCalorie: Int?){
        self.username = username
        self.password = password
        self.picture = picture
        self.dailyCalorie = dailyCalorie
    }
    
    
    class func currentUser(token: String) -> User?{
        
//        let keychainService = KeychainService()
//        let token = keychainService.getToken()
//    
//        let queue = dispatch_queue_create("com.unfatify.currentUser", DISPATCH_QUEUE_SERIAL)
//        dispatch_sync(queue) { () -> Void in
//            let parseAPI = ParseAPI()
//            // Check if user has a session
//            let parseApi = ParseAPI()
//            if let tokenValue = token{
//                parseApi.currentUser(tokenValue, success: { (data) -> Void in
//
//                
//                    }, failure: { (error) -> Void in
//                        
//                })
//            }else{
//                
//            }
//        }
        return nil
    }
    
    
    
    
    
    
}
