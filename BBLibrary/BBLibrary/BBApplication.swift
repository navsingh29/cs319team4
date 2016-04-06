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
    
    let nc = NSNotificationCenter.defaultCenter()
    let panRec = UIPanGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    
    override init() {
        self.library = BBLibrary.get()!
        super.init()
        nc.addObserver(self, selector: #selector(BBApplication.launched), name: "UIApplicationDidFinishLaunchingNotification", object: nil)
        nc.addObserver(self, selector: #selector(BBApplication.readKey(_:)), name: "UITextFieldTextDidChangeNotification", object: nil)
        let applicationName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        BBLibrary.applicationName = applicationName
        print("|| Init BBApplication")
    }
    
    func launched() {
        if self.windows[0].rootViewController?.traitCollection.forceTouchCapability == UIForceTouchCapability.Available
        {
           deviceSupportTouchForce = true
        } else {
           deviceSupportTouchForce = false
        }
    }
    
    func readKey(notification: NSNotification) {
        self.library.captureKeyEvent(notification)
    }
    
    override public func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        if event.type == UIEventType.Touches {
            self.library.captureTouchEvent(event)
        } else {
            // Can be used to capture motion events and remote events(such as earphones)
            print("notTouchEvent:", event)
        }
    }
}