//
//  BBLibraryTests.swift
//  BBLibraryTests
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import XCTest
@testable import BBLibrary

class BBLibraryTests: XCTestCase {
    
    //var config: BBConfiguration;
   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        /*
        self.config = BBConfiguration(
            serverIP: "184.66.140.77:8095",
            domainID: "test",
            cacheSize: 3,
            sendRate: 2,
            enabledComponents: BBComponents.allValues,
            callback: {_ in}
        )
        */
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerUserIDRequirement() {
        let expectation = expectationWithDescription("Data send to server")
        let server = ServerConnection(ip: "184.66.140.77:8095", domainID: "test", callback: {_ in})
        let data = [DataPacket(data: [String:String]())]
        var outcome = false
        
        server.send(data) {
            result in
            outcome = result
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5) {
            error in // TODO: Test error
            
            XCTAssert(!outcome, "Server sent data, in spite of having no user ID.")
        }
    }
    
    func testServerSend() {
        let expectation = expectationWithDescription("Data send to server")
        let server = ServerConnection(ip: "184.66.140.77:8095", domainID: "test", callback: {_ in})
        let data = [DataPacket(data: [String:String]())]
        var outcome = false
        
        server.setUserID("testuser");
        
        server.send(data) {
            result in
            outcome = result
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5) {
            error in // TODO: Test error
            
            XCTAssert(outcome, "Server failed to send data.")
        }
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    */
    
}
