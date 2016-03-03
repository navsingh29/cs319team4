//
//  BBLibraryTests.swift
//  BBLibraryTests
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import XCTest
import SocketIOClientSwift
@testable import BBLibrary

class ServerConnectionTests: XCTestCase {
    
    let serverIP = "http://localhost:8080"
    let domainID = "test"
   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerConnection() {
        let expectation = expectationWithDescription("Connect to server")
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
        
        server.socket.on("connect") { data, ack in
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) {
            error in // TODO: Test error
            XCTAssert(server.socket.status == .Connected);
        }
    }
    
    func testServerUserIDRequirement() {
        let expectation = expectationWithDescription("Data send to server")
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
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
        let expectation = expectationWithDescription("Send data to server")
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
        let dummyData = [DataPacket(data: [String:String]())]
        var outcome = false
        
        server.setUserID("testuser")
        
        server.socket.on("connect") { data, ack in
            server.send(dummyData) {
                result in
                outcome = result
                expectation.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(20) {
            error in // TODO: Test error
            XCTAssert(outcome, "Server failed to send data.")
        }
    }
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    */
    
}
