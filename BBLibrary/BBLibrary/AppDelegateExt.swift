//
//  AppDelegateSub.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-03-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit
import Foundation

class UIApp: UIApplication {
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
//        print("Event sent: \(event)");
        print("Event")
    }
}