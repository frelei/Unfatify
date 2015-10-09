//
//  User.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class User {

    var objectID:String?
    var username:String?
    var picture:String?
    var dailyCalorie: Int?
    var email:String?
    var createdAt:String?
    var updateAt:String?
    var weight:Int?
    var height:Int?
    var sessionToken: String?{
        willSet (newToken){
            let keychainService = KeychainService()
            keychainService.setToken(newToken!)
        }
    }
    
    init(objectID: String, username: String, picture: String, dailyCalorie: Int, email:String, token:String, updateAt:String, createdAt:String){
        self.objectID = objectID
        self.username = username
        self.picture = picture
        self.dailyCalorie = dailyCalorie
        self.email = email
        self.sessionToken = token
        self.updateAt = updateAt
        self.createdAt = createdAt
    }
    
   class func currentUser(token: String) -> User?{
        
        var currentUser: User?
        
        let semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let parseApi = ParseAPI()
                parseApi.currentUser(token, success: { (data) -> Void in
                    currentUser = self.jsonToUser(data as! [String:AnyObject])
                    dispatch_semaphore_signal(semaphore)
                }, failure: { (error) -> Void in
                    dispatch_semaphore_signal(semaphore)
                })
        }
       dispatch_semaphore_wait(semaphore,  DISPATCH_TIME_FOREVER)
       return currentUser
    }
    
    // MARK: AUXILIAR METHODS
    
    
    class func jsonToUser(data: [String:AnyObject]) -> User{
        return User.init(objectID: data["objectId"] as! String,
                        username: data["username"] as! String,
                        picture: data["picture"] as! String,
                        dailyCalorie: data["dailyCalorie"] as! Int,
                        email: data["email"] as! String,
                        token: data["sessionToken"] as! String,
                        updateAt: data["updatedAt"] as! String,
                        createdAt: data["createdAt"] as! String)
        
    }
    
     class func userToJson(user: User) -> [String:AnyObject]{
          let dictionary =  ["username": user.username as! AnyObject,
                             "picture": user.picture as! AnyObject,
                             "dailyCalorie": user.dailyCalorie as! AnyObject,
                             "email":user.email as! AnyObject]
        
        return dictionary
          
    }
    
    
}
