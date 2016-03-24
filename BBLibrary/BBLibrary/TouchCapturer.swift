//
//  TouchCapturer.swift
//  BBLibrary
//
//  Created by Jun on 2016-03-06.
//
//

import Foundation
import UIKit

class TouchCapturer {
    let cache:Cache
    private var count:Int
    private var isEvent:Bool
    private var eventType:BBEvent
    private var startTime:Double
    private var span:Double
    
    init (cache: Cache) {
        self.cache = cache
        self.count = 0
        self.isEvent = false
        self.eventType = .Mono
        self.startTime = 0
        self.span = 0
    }
    
    func processTouchEvent (event: UIEvent) {
        var touches:Set<UITouch>
        var dataPacket: DataPacket
        var currentTouch:UITouch
        
        print("|| TouchCapturer Event\n")
        if let temp = event.allTouches() {
            touches = temp
            if touches.count > 1 {
                print("multi touch")
                for touch in touches {
                    currentTouch = touch
                }
            } else {
                for touch in touches {
                    currentTouch = touch
                    print("phase", (touch.phase.rawValue))
                    print("tap count", (touch.tapCount))
                    switch touch.phase {
                    case .Began:
                        self.startTime = event.timestamp
                        self.eventType = .Mono
                        print("Began")
                        // event.timestamp.description is the same as event.timestamp
                        print("self touchStartTime", self.startTime)
                        print("time", event.timestamp)

                    case .Moved:
                        self.eventType = .Di
                        if self.startTime == 0 {
                            self.startTime = event.timestamp
                        } else {
                            isEvent = true
                            self.span = event.timestamp - self.startTime
                        }
                        print("Moved")
                    case .Stationary:
                        print("Stationary")
                    case .Ended:
                        isEvent = true
                        self.span = event.timestamp - self.startTime
                        print("Ended", self.span)
                    case .Cancelled:
                        print("Cancelled")
                    }
                    
                    if isEvent {
                        //            let evtType = self.eventType
                        print("evtType: ",self.eventType.description, "\nspan:",String(format:"%f", self.span),"\nevtStartTime: ", self.startTime,"\nx is:",currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description,"\npreciseX: ", currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description)
                        print("orientation: ", getDeviceOrientation(UIDevice.currentDevice()))
                        print("interfaceOrientation: ", getInterfaceOrientation(BBApplication.sharedApplication()))
//                        print("interfaceOrientation: ", BBApplication.sharedApplication().supportedInterfaceOrientationsForWindow((BBApplication.sharedApplication().delegate?.window)!).rawValue)
                        
                        dataPacket  = DataPacket(data: ["evtType":self.eventType.description, "startTime":String(format:"%f",self.startTime), "deviceOrientation":getDeviceOrientation(UIDevice.currentDevice()),"previousX":currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "previousY":currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description, "currentX":currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "currentY":currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "preciseCurrentX":currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "preciseCurrentY":currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description, "span":String(format:"%f", self.span),"screenOrientation":getInterfaceOrientation(BBApplication.sharedApplication())],datetime: NSDate())
                        cache.store(dataPacket)
                        self.count = 0
                        isEvent = false
                        self.startTime = 0
                    }

                }
                
                
            }
        }
    }
    
    private func getDeviceOrientation(device: UIDevice) -> String {
        switch device.orientation {
        case .Unknown:
            return "unknown"
        case .Portrait:
            return "portrait"
        case .PortraitUpsideDown:
            return "portraitUpsideDown"
        case .LandscapeLeft:
            return "landscapeLeft"
        case .LandscapeRight:
            return "landscapeRight"
        case .FaceUp:
            return "faceUp"
        case .FaceDown:
            return "faceDown"
        }
        
    }
    
    private func getInterfaceOrientation(app: UIApplication) -> String {
        switch app.statusBarOrientation {
        case .Unknown:
            return "unknown"
        case .Portrait:
            return "portrait"
        case .PortraitUpsideDown:
            return "portraitUpsideDown"
        case .LandscapeLeft:
            return "landscapeLeft"
        case .LandscapeRight:
            return "landscapeRight"
        }
    }
}