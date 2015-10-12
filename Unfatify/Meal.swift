//
//  Meal.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class Meal {

    let name : String?
    let calorie: Int?
    let pointerUser: AnyObject?
    
    init(name: String, calorie: Int, pointerUser: AnyObject){
        self.name = name
        self.calorie = calorie
        self.pointerUser = pointerUser
    }
}
