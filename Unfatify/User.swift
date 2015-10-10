//
//  User.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

/// User responsable to hold and perform actions to user
class User {

    // MARK : ATTRIBUTES
    var objectID:String?
    var username:String?
    var picture:String?
    var dailyCalorie: NSNumber?
    var email:String?
    var createdAt:String?
    var updateAt:String?
    var weight:Int?
    var height:Int?
    var sessionToken: String?{
        willSet (newToken){
            if newToken != nil{
                let keychainService = KeychainService()
                keychainService.setToken(newToken!)
            }
        }
    }
    
    init(objectID: String?, username: String?, picture: String?, dailyCalorie: NSNumber?, email:String?, token:String?, updateAt:String?, createdAt:String?){
        self.objectID = objectID
        self.username = username
        self.picture = picture
        self.dailyCalorie = dailyCalorie
        self.email = email
        self.sessionToken = token
        self.updateAt = updateAt
        self.createdAt = createdAt
    }
    
    // MARK:
    
   /**
      Retrieve user from parse based on token session  

    */
   class func currentUser(token: String) -> User?{
        
     var currentUser: User?
     let parseApi = ParseAPI()
     let semaphore = dispatch_semaphore_create(0)
     parseApi.currentUser(token, success: { (data) -> Void in
                    currentUser = self.jsonToUser(data as! [String:AnyObject])
                    dispatch_semaphore_signal(semaphore)
                }, failure: { (error) -> Void in
                    currentUser = nil
                    dispatch_semaphore_signal(semaphore)
                })
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      return currentUser
    }
    
    // MARK: HELPER METHODS
    
    class func jsonToUser(data: [String:AnyObject]) -> User{
        
        return User.init(objectID: data["objectId"] as? String,
                        username: data["username"] as? String,
                        picture: data["picture"] as? String,
                        dailyCalorie: data["dailyCalorie"] as? NSNumber,
                        email: data["email"] as? String,
                        token: data["sessionToken"] as? String,
                        updateAt: data["updatedAt"] as? String,
                        createdAt: data["createdAt"] as? String)
    }
    
     class func userToJson(user: User) -> [String:AnyObject]{
          let dictionary =  ["username": user.username as! AnyObject,
                             "picture": user.picture as! AnyObject,
                             "dailyCalorie": user.dailyCalorie as! AnyObject,
                             "email":user.email as! AnyObject]
        return dictionary
          
    }
    
    
}
