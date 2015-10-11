//
//  UserMeal.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class UserMeal {

    var objectId: String?
    var name: String?
    var calorie: NSNumber?
    var date: String?
    var createdAt:String?
    var updateAt:String?
    var userPointer:[String:AnyObject]?
    
    // MARK: INITIALIZERS
    init(objectId: String?, name: String?, calorie: NSNumber?, date: String?, updateAt:String?, createdAt:String?, userPointer:[String:AnyObject]?){
        self.objectId = objectId
        self.name = name
        self.calorie = calorie
        self.date = date
        self.updateAt = updateAt
        self.createdAt = createdAt
        self.userPointer = userPointer
    }
    

    // MARK: HELPER METHODS
    class func jsonToUserMeal(data: [String:AnyObject]) -> UserMeal{
        return UserMeal.init(objectId: data["objectId"] as? String,
                             name: data["name"] as? String,
                             calorie: data["calorie"] as? NSNumber,
                             date: data["date"] as? String,
                             updateAt: data["updatedAt"] as? String,
                             createdAt: data["createdAt"] as? String,
                             userPointer: data["user"] as? [String: AnyObject])
    }
    
    class func userMealToJson(userMeal: UserMeal, objectId:String) -> [String:AnyObject]{
        return ["name": userMeal.name as! AnyObject,
                "calorie": userMeal.calorie as! AnyObject,
                "date":  userMeal.date as! AnyObject,
                "user": UserMeal.createUserPointer(objectId)]
    }
    
    class func createUserPointer(objectId: String) -> [String:AnyObject]{
        return  ["__type":"Pointer","className":"_User","objectId":objectId]
    }
    
    
}
