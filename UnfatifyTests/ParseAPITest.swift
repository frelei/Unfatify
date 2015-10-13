//
//  ParseAPITest.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import XCTest
@testable import Unfatify

class ParseAPITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testCreateObject() {
        let parseAPI = ParseAPI()
        let className = "Meal"
        let classData = ["name":"Kobe Beef","calorie": 500];
        let token = "r:2wf1umC4mNiAyWB4uwHTw7Ww5"
        let expectation = expectationWithDescription("TEST_CREATE_OBJECT")
        
        parseAPI.createObject(className, token:token, data: classData,
            success: { (data) -> Void in
                XCTAssertNotNil(data, "SUCCESS")
                expectation.fulfill()
            }, failure: { (error) -> Void in
                XCTAssertNotNil(error, "ERROR")
                expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testFailCreateObject() {
        let parseAPI = ParseAPI()
        let className = "Meal"
        let classData = ["name":"Kobe Beef","calorie": "500"];
        let expectation = expectationWithDescription("TEST_CREATE_OBJECT")
        let token = "r:2wf1umC4mNiAyWB4uwHTw7Ww5"
        
        parseAPI.createObject(className, token:token, data: classData,
            success: { (data) -> Void in
                XCTAssertNotNil(data, "SUCCESS")
                expectation.fulfill()
            }, failure: { (error) -> Void in
                XCTAssertNotNil(error, "ERROR")
                expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    
    func testRetrieveObject(){
        let parseAPI = ParseAPI()
        let className = "UserMeal"
        
        let expectation = expectationWithDescription("TEST_CREATE_OBJECT")
        parseAPI.retrieveObject(className, objectId: "xNWSKsXEJJ", success: { (data) -> Void in
                XCTAssertNotNil(data, "SUCCESS")
                expectation.fulfill()
            }, failure: { (error) -> Void in
                XCTAssertNotNil(error, "ERROR")
                expectation.fulfill()
        })

        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testUpdateObject(){
        let parseAPI = ParseAPI()
        let className = "Meal"
        let classData = ["calorie": "1000"];
        let expectation = expectationWithDescription("TEST_UPDATE_OBJECT")
        
        parseAPI.updateObject(className, objectId: "xNWSKsXEJJ", data: classData, success: { (data) -> Void in
                XCTAssertNotNil(data, "SUCCESS")
                expectation.fulfill()
            },failure: { (error) -> Void in
                XCTAssertNotNil(error, "ERROR")
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
        
    }
    
}
