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
    
    init (cache: Cache) {
        self.cache = cache
    }
    
    func processTouchEvent (event: UIEvent) {
        var touches:Set<UITouch>

        var dataPacket: DataPacket
        print("|| TouchCapturer Event\n")
        touches = event.allTouches()!
        print(touches)
        for touch in touches {
            print("phase", (touch.phase.rawValue))
            switch touch.phase {
            case .Began:
                print("Began")
            case .Moved:
                print("Moved")
            case .Stationary:
                print("Stationary")
            case .Ended:
                print("Ended")
            case .Cancelled:
                print("Cancelled")
            }
            
        }
        dataPacket  = DataPacket(data: ["description":event.description],datetime: NSDate())
        cache.store(dataPacket)
    }
}