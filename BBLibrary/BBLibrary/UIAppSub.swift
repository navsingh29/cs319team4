//
//  AppDelegateSub.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-03-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

public class UIAppSub: UIApplication {

    override init() {
        super.init()
        let configuration = BBConfiguration(serverIP:"localhost", domainID:"domainID", cacheSize:1024, sendRate:10, enabledComponents: [BBComponents.TouchEvents], callback: {_ in})
        let bblibrary = BBLibrary(args: configuration)
        print("init")
    }
    
    override public func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        print("Event sent: \(event)")
        print("Event",event.timestamp)
    }
}