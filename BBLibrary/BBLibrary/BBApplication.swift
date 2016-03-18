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
        //self.delegate?.window = AppUiWin()
        super.init()
        nc.addObserver(self, selector: "launched", name: "UIApplicationDidFinishLaunchingNotification", object: nil)
        nc.addObserver(self, selector: "readKey:", name: "UITextFieldTextDidChangeNotification", object: nil)
        nc.addObserver(self, selector: "winVisible:", name: "UIWindowDidBecomeVisibleNotification", object: nil)
        print("init")
        
    }
    func winVisible(notification: NSNotification) {
        panRec.addTarget(self, action: "draggedView:")
//        (notification.object as! UITextField)
        (notification.object as! UIWindow).rootViewController?.view.addGestureRecognizer(panRec)
        print("Window is visible")
    }

    func tap() {
        print("tap")
    }
    
    func launched() {
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
        
//        panRec.addTarget(self, action: "draggedView:")
//        self.windows[0].rootViewController?.view.addGestureRecognizer(panRec)
        
        pinchRec.addTarget(self, action: "pinchedView:")
        self.windows[0].rootViewController?.view.addGestureRecognizer(pinchRec)
    }
    
    func draggedView(gesture: UIPanGestureRecognizer) {
        print("dragged")
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
//        print(self.applicationState.rawValue)
        super.sendEvent(event)
//        print(self.windows[0].rootViewController?.view, "UIWindow view")
//        print(self.windows.count, "num of windows")
//        for var i = 0; i < self.windows.count; ++i {
//                print(self.windows[i])
//        }
        
        if event.type == UIEventType.Touches {
//            BBApplication.sharedApplication().delegate?.performSelector("processEvent:",withObject: event)
            self.library.captureTouchEvent(event)
        } else {
            print("notTouchEvent:", event)
        }
    }
    
}