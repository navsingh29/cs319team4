//
//  AppUIWin.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-02-29.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class AppUiWin: UIWindow {

//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//       let uiview = super.hitTest(point, withEvent: event)
//        print("hittest",event?.type)
//        print("uiview",uiview)
//        print("event",event)
//       print("point",point)
//        print("")
//        return super.hitTest(point, withEvent: event)
//    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        print("point",point)
        print("hittest",event?.type)
        print("event",event?.subtype)
        print("")
        return super.pointInside(point, withEvent: event)
    }
    
    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            print("touch",event)
            
            super.touchesBegan(touches , withEvent:event)
    }
    
}
