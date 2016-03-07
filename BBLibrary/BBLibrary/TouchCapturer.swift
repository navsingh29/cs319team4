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
        // not sure if this the right way to declare @Devindra
        var dataPacket: DataPacket
        print("|| TouchCapturer Event",event.description)
        dataPacket  = DataPacket(data: ["description":event.description],datetime: NSDate())
        cache.store(dataPacket)
    }
}