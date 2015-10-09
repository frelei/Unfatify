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
    var email:String?
    var createdAt:NSDate?
    var updateAt:NSDate?
    var weight:Int?
    var height:Int?
    
    init(username: String, password: String, picture: String, dailyCalorie: Int?){
        self.username = username
        self.password = password
        self.picture = picture
        self.dailyCalorie = dailyCalorie
    }
    
    
    class func currentUser(token: String) -> User?{
        
        var currentUser: User?
        
        let semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let parseApi = ParseAPI()
                parseApi.currentUser(token, success: { (data) -> Void in
                    dispatch_semaphore_signal(semaphore)
                }, failure: { (error) -> Void in
                    dispatch_semaphore_signal(semaphore)
                })
        }
        
       dispatch_semaphore_wait(semaphore,  DISPATCH_TIME_FOREVER)
       return currentUser
    }
    
}
