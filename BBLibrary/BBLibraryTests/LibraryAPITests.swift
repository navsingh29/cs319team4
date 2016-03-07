//
//  LibraryAPITests.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-03-03.
//
//

import XCTest
@testable import BBLibrary

class LibraryAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetUserID() {
        let config = BBConfiguration(serverIP: "", domainID: "test", cacheSize: 10, sendRate: 10, enabledComponents: BBComponents.allValues, callback: {_ in})
        let library = BBLibrary(args: config)
        
        library.setUserID("testuser")
        
        XCTAssertEqual(library.server.userID, "testuser")
    }
}