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
    private var isEvent:Bool
    private var eventType:BBEvent
    private var startTime:Double
    private var span:Double
    private var previousTouches:Set<UITouch>
    private var prevTouches:[TouchCount]
    private struct TouchUnit {
        var phase: UITouchPhase
        var startTime: Double
        var previousX: String
        var previousY: String
        var currentX: String
        var currentY: String
        var preciseCurrentX: String
        var preciseCurrentY: String
    }
    private struct TouchIndex {
        var index:Int
        var touchUnit:TouchUnit
    }
    private struct TouchCount {
        var count:Int
        var touch:UITouch
    }
    
    init (cache: Cache) {
        self.cache = cache
        self.isEvent = false
        self.eventType = .Mono
        self.startTime = 0
        self.span = 0
        self.previousTouches = []
        self.prevTouches = []
    }
    
    func processTouchEvent (event: UIEvent) {
        var touches:Set<UITouch>
        var dataPacket: DataPacket
        var currentTouch:UITouch
        
        print("|| TouchCapturer Event")
        if let temp = event.allTouches() {
            touches = temp
            if touches.count >= 1 {
                for touch in touches {
                    currentTouch = touch
                    let previousTouchCount = getPreviousTouchCount(touch)
                    // For all End UITouchPhase, its previous location is not the same as the location of the previous UITouch,
                    // instead, End UITouches have the same locations(current and previous) as the previous UITouch
                    if previousTouchCount != nil {
                        switch touch.phase {
                        // theorectically, it won't be case Began
                        case .Began:
                            print("Began")
                        case .Moved:
                            self.eventType = .Di
                            isEvent = true
                            self.span = event.timestamp - self.startTime
                            print("Moved")
                        case .Stationary:
                            print("Stationary")
                            self.span = event.timestamp - self.startTime
                            self.eventType = .Di
                            isEvent = true
                        case .Ended:
                            print("Ended")
                            self.span = event.timestamp - self.startTime
                            if (removePreviousTouch(currentTouch) <= 1) {
                                self.eventType = .Mono
                            } else {
                                self.eventType = .Di
                            }
                            isEvent = true
                        case .Cancelled:
                            print("Cancelled")
                            self.span = event.timestamp - self.startTime
                            if (removePreviousTouch(currentTouch) <= 1) {
                                self.eventType = .Mono
                            } else {
                                self.eventType = .Di
                            }
                            isEvent = true
                        }
                    } else {
                        self.prevTouches.append(TouchCount(count: 0,touch: currentTouch))
                    }
                    
                    if isEvent {
                        print("|| send the following packet:")
                        //deviceOrientation of a DiTouch event is the orientation at the second event
                        let touchType = getTouchType(currentTouch)
                        let radius = touch.majorRadius
                        let radiusTolerance = touch.majorRadiusTolerance
                        var force = CGFloat(0)
                        if deviceSupportTouchForce {
                            force = touch.force
                        }
                        dataPacket  = DataPacket(data: [
                            "evtType": self.eventType.description,
                            "touchType": touchType,
                            "startTime": String(format:"%f", self.startTime),
                            "deviceOrientation": getDeviceOrientation(UIDevice.currentDevice()),
                            "previousX": currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description,
                            "previousY": currentTouch.previousLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description,
                            "currentX": currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).x.description,
                            "currentY": currentTouch.locationInView((BBApplication.sharedApplication().delegate?.window)!).y.description,
                            "preciseCurrentX": currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).x.description,
                            "preciseCurrentY": currentTouch.preciseLocationInView((BBApplication.sharedApplication().delegate?.window)!).y.description,
                            "force": String(format:"%f", force),
                            "radius": String(format:"%f", radius),
                            "radiusTolerance": String(format:"%f", radiusTolerance),
                            "span":String(format:"%f", self.span),
                            "screenOrientation": getInterfaceOrientation(BBApplication.sharedApplication())],datetime: NSDate())
                        print(dataPacket.values)
                        cache.store(dataPacket)
                        isEvent = false
                    }
                }
                
                // Update the timestamp for the next round of TouchEvents
                self.startTime = event.timestamp
            }
        }
    }
    
    /* Remove a UITouch from the prevTouch array */
    private func removePreviousTouch(touch: UITouch) -> Int {
        for (index, touchCount)  in self.prevTouches.enumerate() {
            if touchCount.touch == touch {
                let count = self.prevTouches[index].count
                self.prevTouches.removeAtIndex(index)
                return count
            }
        }
        return 0
    }
    
    /* Check if a UITouch is a consecutive UITouch from a array of UITouch */
    private func getPreviousTouchCount(touchEvt: UITouch) -> UITouch? {
        if self.prevTouches.isEmpty { return nil }
        for (index, touchCount)  in self.prevTouches.enumerate() {
            if touchCount.touch == touchEvt {
                self.prevTouches[index].count += 1
                return touchEvt
            }
        }
        return nil
    }
    
    /* Get type of UITouch: direct finger, indirect, stylus */
    private func getTouchType(touch: UITouch) -> String {
        switch touch.type {
        case .Direct:
            return "direct"
        case .Indirect:
            return "indirect"
        case .Stylus:
            return "stylus"
        }
    }

    /* Get device orientation */
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
    
    /* Get Application's UI Interface orientation */
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