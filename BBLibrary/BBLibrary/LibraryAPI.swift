//
//  BBLibrary.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation
import UIKit

public enum BBComponents {
    case KeyEvents, TouchEvents, PhoneData
    static let allValues = [KeyEvents, TouchEvents, PhoneData]
}

public enum BBResponse {
    case Authorized, NotAuthorized
}

public struct BBConfiguration {
    let serverIP: String
    let domainID: String
    let cacheSize: Int
    let sendRate: Int
    let enabledComponents: [BBComponents]
    var callback: (BBResponse) -> ()
    //let touchListener // TODO: Implement some object that we can listen to for touches.
}

public class BBLibrary {
    public let version = "1.0"
    internal let config: BBConfiguration // Use of "let" (instead of "var") signals that this value cannot be changed.
    private var touchCapturer: TouchCapturer?
    private let server: ServerConnection
    private let cache: Cache
    
    public init(args: BBConfiguration) {
        self.config = args
        
        self.server = ServerConnection(ip: args.serverIP, domainID: args.domainID, callback: args.callback)
        self.cache = Cache(server: server, size: args.cacheSize, rate: args.sendRate)
        
        if config.enabledComponents.contains(.KeyEvents) {
            // TODO: Initialize the Key Events Capturer
            // Don't forget to pass the cache object to your new class.
            
        }
        
        if config.enabledComponents.contains(.TouchEvents) {
            // TODO: Initialize the Touch Events Capturer
            // Don't forget to pass the cache object to your new class.
            self.touchCapturer = TouchCapturer(cache: self.cache)
        }
        
        if config.enabledComponents.contains(.PhoneData) {
            // TODO: Initialize the Phone Data Capturer
            // Don't forget to pass the cache object to your new class.
        }
    }
    
    public func setUserID(userID: String) {
        self.server.setUserID(userID)
    }
    
    public func captureTouchEvent(event: UIEvent) {
        if let touchCapt = touchCapturer {
            touchCapt.processTouchEvent(event)
        }
    }
}