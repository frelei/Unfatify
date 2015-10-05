//
//  WebServiceTest.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import XCTest
@testable import Unfatify

class WebServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testGet(){
        let expectation = expectationWithDescription("TEST_GET")
        let webService = WebService()
        webService.connection( WebServiceConnectionType.GET, url: "http://jsonplaceholder.typicode.com/posts/1", params: [:], header: [:],
            success: { (JSON) -> Void in
                XCTAssertNotNil(JSON, "SUCCESS")
                expectation.fulfill()
            }, failure: { (ERROR) -> Void in
                XCTAssertNotNil(ERROR, "ERROR")
                expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }

    
    func testPost(){
        let expectation = expectationWithDescription("TEST_POST")
        let webService = WebService()
        webService.connection(WebServiceConnectionType.POST, url: "http://jsonplaceholder.typicode.com/posts", params: ["title" : "foo", "body":"bar", "userID": "1"], header: [:],
            success: { (JSON) -> Void in
                XCTAssertNotNil(JSON, "SUCCESS")
                expectation.fulfill()
            }, failure: { (ERROR) -> Void in
               XCTAssertNotNil(ERROR, "ERROR")
               expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    
    func testPut(){
        let expectation = expectationWithDescription("TEST_PUT")
        let webService = WebService()
        webService.connection(WebServiceConnectionType.PUT, url: "http://jsonplaceholder.typicode.com/posts/1", params: ["title" : "foo", "body":"bar", "userID": "1"], header: [:],
            success: { (JSON) -> Void in
                XCTAssertNotNil(JSON, "SUCCESS")
                expectation.fulfill()
            }, failure: { (ERROR) -> Void in
                XCTAssertNotNil(ERROR, "ERROR")
                expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    
    func testDelete(){
        let expectation = expectationWithDescription("TEST_DELETE")
        let webService = WebService()
        webService.connection(WebServiceConnectionType.PUT, url: "http://jsonplaceholder.typicode.com/posts/1", params: [:], header: [:],
            success: { (JSON) -> Void in
                XCTAssertNotNil(JSON, "SUCCESS")
                expectation.fulfill()
            }, failure: { (ERROR) -> Void in
                XCTAssertNotNil(ERROR, "ERROR")
                expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertNil(error, "Error")
        })
    }
    
    
}
