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

class CacheTests: XCTestCase {
    
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
    
    func testCacheStorage() {
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
        let cache = Cache(server: server, size: 10, rate: 10)
        let packet = DataPacket(data: [String:String]())
        
        XCTAssertEqual(cache.data.count, 0)
        cache.store(packet)
        XCTAssertEqual(cache.data.count, 1)
        cache.store(packet)
        XCTAssertEqual(cache.data.count, 2)
    }
    
    func testCacheLimit() {
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
        let cache = Cache(server: server, size: 1, rate: 10)
        let packet = DataPacket(data: [String:String]())
        
        XCTAssertEqual(cache.data.count, 0)
        cache.store(packet)
        XCTAssertEqual(cache.data.count, 1)
        cache.store(packet)
        XCTAssertEqual(cache.data.count, 1)
    }
    
    func testSendRate() {
        let server = ServerConnection(ip: serverIP, domainID: domainID, callback: {_ in})
        let cache = Cache(server: server, size: 10, rate: 2)
        let packet = DataPacket(data: [String:String]())
        
        server.setUserID("testuser")
        sleep(5) // Give the server time to connect.
        
        XCTAssertEqual(cache.data.count, 0)
        cache.store(packet)
        XCTAssertEqual(cache.data.count, 1)
        cache.store(packet)
        
        sleep(20)
        XCTAssertEqual(cache.data.count, 0)
    }
}
