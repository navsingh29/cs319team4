//
//  AppDelegateSub.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-03-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

public class BBApplication: UIApplication {
    internal var library: BBLibrary
    
    //let serverIP = "ws://echo.websocket.org"
    let serverIP = "ws://btdemo.plurilock.com:8095"
    //let serverIP = "http://localhost:8080"
    
    override init() {
        let configuration = BBConfiguration(serverIP: serverIP, domainID: "testDomainT4", cacheSize: 1024, sendRate: 10, enabledComponents: [.TouchEvents], callback: {_ in})
        self.library = BBLibrary(args: configuration)
        self.library.setUserID("testUserT4")
        
        super.init()
        print("init")
    }
    
    override public func sendEvent(event: UIEvent) {
        print(self.applicationState.rawValue)
        super.sendEvent(event)
        
        if event.type == UIEventType.Touches {
            BBApplication.sharedApplication().delegate?.performSelector("processEvent:",withObject: event)
        } else {
            print("notTouchEvent:", event)
        }
    }
    
}