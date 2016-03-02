//
//  AppUIWin.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-02-29.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class AppUiWin: UIWindow {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let uiview = super.hitTest(point, withEvent: event)
        print("hittest",event)
        print("hittest",uiview)
        return nil
    }
}