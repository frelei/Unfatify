//
//  Query.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class Query {
    
    var query: String
    
    init(){
        self.query = "where={"
    }
    
    func addObject(object: [String:AnyObject], column:String){
        for (key,value) in object{
            self.query += "\"\(column)\":{\"\(key)\":\"\(value)\"},"
        }
    }
    
    func addPointer(className:String, objectId:String, column:String){
        self.query += "\"\(column)\":{\"__type\":\"Pointer\",\"className\":\"\(className)\",\"objectId\":\"\(objectId)\"},"
    }
    
    
    func addDateGte(date:String, column:String){
        self.query += "\"\(column)\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"\(date)\"}},"
    }
    
    func addDateLte(date:String, column:String){
        self.query += "\"\(column)\":{\"$lte\":{\"__type\":\"Date\",\"iso\":\"\(date)\"}},"
    }
    
    func getQuery() -> String{
        if self.query[self.query.endIndex.predecessor()] == ","{
            self.query = String(self.query.characters.dropLast())
        }
            self.query += "}"
        return self.query
    }

    func getQueryEncoded() -> String{
        if self.query[self.query.endIndex.predecessor()] == ","{
            self.query = String(self.query.characters.dropLast())
        }
            self.query += "}"
        return  query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
}
