//
//  AppDelegateSub.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-03-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

public class BBApplication: UIApplication {
    internal let library: BBLibrary

    override init() {
        let configuration = BBConfiguration(serverIP:"http://localhost:8080", domainID:"test", cacheSize:1024, sendRate:10, enabledComponents: [BBComponents.TouchEvents], callback: {_ in})
        self.library = BBLibrary(args: configuration)
        super.init()
        print("init")
    }
    
    override public func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        if event.type == UIEventType.Touches {
            print("Event",event.timestamp)
            self.library.captureTouchEvent(event)
        } else {
            print("notTouchEvent:", event)
        }
        
    }
}