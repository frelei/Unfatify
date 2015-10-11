//
//  QueryTest.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import XCTest
@testable import Unfatify

class QueryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddObject(){
        let query = Query()
        query.addObject(["name":"Beef"], column: "UserMeal")
        XCTAssertEqual(query.getQuery(), "where={\"UserMeal\":{\"name\":\"Beef\"}}")
    }
    
    func testAddPointer(){
        let query = Query()
        query.addPointer("_User", objectId: "XXD45FxcA", column: "user")
        XCTAssertEqual(query.getQuery(), "where={\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"XXD45FxcA\"}}")
    }
    
    func testAddDateGte(){
        let query = Query()
        query.addDateGte("2011-08-21T18:02:52.249Z", column: "date")
        XCTAssertEqual(query.getQuery(), "where={\"date\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"2011-08-21T18:02:52.249Z\"}}}")

    }
    
    func testCompoundObjects(){
        let query = Query()
        query.addObject(["name":"Beef"], column: "UserMeal")
        query.addPointer("_User", objectId: "XXD45FxcA", column: "user")
        XCTAssertEqual(query.getQuery(), "where={\"UserMeal\":{\"name\":\"Beef\"},\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"XXD45FxcA\"}}")
        
    }
}
