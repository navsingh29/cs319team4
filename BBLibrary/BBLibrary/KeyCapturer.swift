//
//  KeyCapturer.swift
//  BBLibrary
//
//  Created by Kim Prap on 3/10/16.
//
//

import Foundation
import UIKit

class KeyCapturer {
    
    let cache: Cache
    var prevTextSize = 0
    
    init (cache: Cache) {
        self.cache = cache
    }
    
    func processKeyEvent (notification: NSNotification) {
        //let keyPressed = (notification.object as! UITextField).text!
        let textSize = ((notification.object as! UITextField).text!).characters.count
        let str = ((notification.object as!UITextField).text!).characters
        if (prevTextSize == textSize+1 && prevTextSize>0) {
            print("Key Pressed: Backspace")
            prevTextSize = textSize
            print("Text size = \(textSize)")
            print("Prev text = \(prevTextSize)")
        }
        else {
            print("Key Pressed: \(str.last!)")
            prevTextSize = textSize
        }
        //print("Monograph: \(getMonograph(notification))")
    }
    
    func getMonograph (notification: NSNotification) -> Double{
        var info:[NSObject : AnyObject] = notification.userInfo!
        var value:Double = (info[UIKeyboardAnimationDurationUserInfoKey] as! Double)
        //var duration: NSTimeInterval = 0
        //value.getValue(duration)
        return value
    }
    
}