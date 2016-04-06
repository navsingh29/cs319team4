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
        nc.addObserver(self, selector: #selector(BBApplication.winVisible(_:)), name: "UIWindowDidBecomeVisibleNotification", object: nil)
        print("init")
        
    }
    
    func winVisible(notification: NSNotification) {
        panRec.addTarget(self, action: "draggedView:")
        (notification.object as! UIWindow).rootViewController?.view.addGestureRecognizer(panRec)
        print("Window is visible")
    }

    func tap() {
        print("tap")
    }
    
    func launched() {
        if self.windows[0].rootViewController?.traitCollection.forceTouchCapability == UIForceTouchCapability.Available
        {
           deviceSupportTouchForce = true
        } else {
           deviceSupportTouchForce = false
        }

        let aSelector : Selector = "tap"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        self.windows[0].rootViewController?.view.addGestureRecognizer(tapGesture)
       
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.windows[0].rootViewController?.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.windows[0].rootViewController?.view.addGestureRecognizer(swipeDown)
        
        panRec.addTarget(self, action: "draggedView:")
        self.windows[0].rootViewController?.view.addGestureRecognizer(panRec)
        
        pinchRec.addTarget(self, action: #selector(BBApplication.pinchedView(_:)))
        self.windows[0].rootViewController?.view.addGestureRecognizer(pinchRec)
    }
    
    func draggedView(gesture: UIPanGestureRecognizer) {
        print("dragged")
    }
    func pinchedView(gesture: UIPinchGestureRecognizer) {
        print("pinched")
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func readKey(notification: NSNotification) {
        self.library.captureKeyEvent(notification)
    }
    
    override public func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        print(event)
        if event.type == UIEventType.Touches {
            self.library.captureTouchEvent(event)
        } else {
            // Can be used to capture motion events and remote events(such as earphones)
            print("notTouchEvent:", event)
        }
    }
    
    
    
}