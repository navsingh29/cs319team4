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
    private var previousTouches:Set<UITouch>
    private var done:Bool
    init (cache: Cache) {
        self.cache = cache
        self.count = 0
        self.isEvent = false
        self.eventType = .Mono
        self.startTime = 0
        self.span = 0
        self.previousTouches = []
        self.done = false
    }
    
    func processTouchEvent (event: UIEvent) {
        var touches:Set<UITouch>
        var dataPacket: DataPacket
        var currentTouch:UITouch
        
        print("|| TouchCapturer Event\n")
        if let temp = event.allTouches() {
            touches = temp
            if touches.count >= 1 {
                print("multi touch")
                for touch in touches {
                    
                    currentTouch = touch
                    let previousTouch = getPreviousTouch(previousTouches,touch: touch)
                    if previousTouch != nil {
                        previousTouches.remove(previousTouch!)
                        switch currentTouch.phase {
                        case .Began:
//                            self.startTime = event.timestamp
//                            self.eventType = .Mono
                            print("Began")
                            // event.timestamp.description is the same as event.timestamp
                            print("self touchStartTime", self.startTime)
                            print("time", event.timestamp)
                            
                        case .Moved:
                            self.eventType = .Di
//                            if self.startTime == 0 {
//                                self.startTime = event.timestamp
//                            } else {
                                isEvent = true
                                self.span = event.timestamp - self.startTime
//                            }
                            print("Moved")
                        case .Stationary:
                            print("Stationary")
                        case .Ended:
                            isEvent = true
                            self.span = event.timestamp - self.startTime
                            print("Ended", self.span)
                        case .Cancelled:
                            print("Cancelled")
//                            if self.startTime != 0 {
                                isEvent = true
                                self.span = event.timestamp - self.startTime
//                            }
                        }

                    } else {
                        previousTouches.insert(currentTouch)
                    }
                    
                    
                    
                    if isEvent {
                        print("previousPhase", previousTouch?.phase.rawValue)
                        print("currentPhase", currentTouch.phase.rawValue)
                        print("isEmpty",previousTouches.isEmpty, previousTouches.count)
                        if (previousTouch?.phase == .Began) && (currentTouch.phase != .Moved) {
                            self.eventType = .Mono
                        }
                        if currentTouch.phase == .Ended || currentTouch.phase == .Cancelled {
                            self.done = true
                        } else {
                            self.done = false
                        }
                        print("send packet")
                        //deviceOrientation of a DiTouch event is the orientation at the second event
                        dataPacket  = DataPacket(data: ["evtType":self.eventType.description, "startTime":String(format:"%f",self.startTime), "deviceOrientation":getDeviceOrientation(UIDevice.currentDevice()),"previousX":currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "previousY":currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description, "currentX":currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "currentY":currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "preciseCurrentX":currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description, "preciseCurrentY":currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description, "span":String(format:"%f", self.span),"screenOrientation":getInterfaceOrientation(BBApplication.sharedApplication())],datetime: NSDate())
                        print(dataPacket.values)
                        cache.store(dataPacket)
                        self.count = 0
                        isEvent = false
                    }

                }
                
                
                if previousTouches.isEmpty && !self.done {
                    previousTouches = touches
                }
                self.startTime = event.timestamp
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
                        if self.startTime != 0 {
                            isEvent = true
                            self.span = event.timestamp - self.startTime
                        }
                    }
                    
                    if isEvent {
                        print("evtType: ",self.eventType.description, "\nspan:",String(format:"%f", self.span),"\nevtStartTime: ", self.startTime,"\nx is:",currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description,"\npreciseX: ", currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description)
                        print("orientation: ", getDeviceOrientation(UIDevice.currentDevice()))
                        print("interfaceOrientation: ", getInterfaceOrientation(BBApplication.sharedApplication()))
                        
                        //deviceOrientation of a DiTouch event is the orientation at the second event
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
    
    /* Check if a UITouch is a consecutive UITouch from a set of UITouch by comparing their x and y coordinates. */
    private func getPreviousTouch(touches:Set<UITouch>, touch:UITouch) -> UITouch? {
        if touches.isEmpty { return nil }
        let x_coord = touch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description
        let y_coord = touch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description
        for touchEvent in touches {
            if (x_coord == touchEvent.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description)
                && (y_coord == touchEvent.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description) {
                    return touchEvent
            }
        }
        return nil
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