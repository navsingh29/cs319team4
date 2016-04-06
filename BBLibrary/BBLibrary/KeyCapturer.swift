//
//  KeyCapturer.swift
//  BBLibrary
//
//  Created by Kim Prap on 3/10/16.
//
//

import Foundation
import UIKit
import QuartzCore

class KeyCapturer {
    
    let cache: Cache
    let DigraphThreshold = 10.0
    let decimalPlaces = 4
    
    var isFirstKey = true
    var firstKeyTime = 0.0
    var firstKeyCode:UInt32 = 0
    var secondKeyCode:UInt32 = 0
    var span = 0.0
    var spanRounded = NSNumberFormatter()
    
    init (cache: Cache) {
        self.cache = cache
    }
    
    func processKeyEvent (notification: NSNotification) {
        
        var dataPacket: DataPacket
        let str = ((notification.object as!UITextField).text!)
        
        spanRounded.minimumFractionDigits = decimalPlaces
        spanRounded.maximumFractionDigits = decimalPlaces
        
        if (str.isEmpty) {
            // Text erased, do nothing.
        }
        else {
            if ((CACurrentMediaTime()-firstKeyTime)<=DigraphThreshold) {
                secondKeyCode = str.unicodeScalars.last!.value
                isFirstKey = false
                span = CACurrentMediaTime() - firstKeyTime
                firstKeyTime = CACurrentMediaTime()
                
                dataPacket = DataPacket.init(data: [
                    "evtType":  "DiKey",
                    "fromKey":  "\(firstKeyCode)",
                    "toKey":    "\(secondKeyCode)",
                    "span":     "\(spanRounded.stringFromNumber(span)!) seconds"])
                
                print(dataPacket.values)
                cache.store(dataPacket)
                
                /*
                dataPacket2 = DataPacket.init(data: [
                    "evtType": "MonoKey",
                    "key":     "\(firstKeyCode)"])
                
                print(dataPacket2.values)
                cache.store(dataPacket2)
                */
            } else {
                firstKeyCode = str.unicodeScalars.last!.value
                isFirstKey = true
                firstKeyTime = CACurrentMediaTime()
                dataPacket = DataPacket.init(data: [
                    "evtType":  "MonoKey",
                    "key":      "\(firstKeyCode)"])
                
                print(dataPacket.values)
                cache.store(dataPacket)
            }
        }
    }
    
}