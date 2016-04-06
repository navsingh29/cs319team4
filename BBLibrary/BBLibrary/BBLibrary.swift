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
    public static let allValues = [KeyEvents, TouchEvents, PhoneData]
}

public enum BBResponse {
    case Authorized, NotAuthorized, Unrecognized
}

internal enum BBEvent: CustomStringConvertible {
    case Mono, Di
    var description : String {
        switch self {
            case .Mono: return "MonoTouch";
            case .Di: return "DiTouch";
        }
    }
}

public let sendEventNotification = "SendEventNotification"

public struct BBConfiguration {
    let serverIP: String
    let domainID: String
    let cacheSize: Int
    let sendRate: Int
    let enabledComponents: [BBComponents]
    let digraphTimeout: Int
    var callback: (BBResponse) -> ()
    //let touchListener // TODO: Implement some object that we can listen to for touches.
    public init(serverIP: String, domainID: String, cacheSize: Int, sendRate: Int, enabledComponents: [BBComponents], digraphTimeout: Int, callback: (BBResponse) -> ()) {
        self.serverIP = serverIP
        self.domainID = domainID
        self.cacheSize = cacheSize
        self.sendRate = sendRate
        self.enabledComponents = enabledComponents
        self.digraphTimeout = digraphTimeout
        self.callback = callback
    }
}

internal var deviceSupportTouchForce = false

internal func setDeviceSupTouchForce(support: Bool) {
    deviceSupportTouchForce = support
}

internal func getDeviceSupTouchForce() -> Bool {
    return deviceSupportTouchForce
}

public class BBLibrary {
    static var library : BBLibrary?
    static var config : BBConfiguration?
    
    public class func configure(config: BBConfiguration) {
        BBLibrary.config = config
    }
    
    // TODO: Make this function throw an error.
    public class func get() -> BBLibrary? {
        if let lib = BBLibrary.library {
            return lib
        } else if let config = BBLibrary.config {
            BBLibrary.library = BBLibrary(args: config)
            return BBLibrary.library
        } else {
            print("BBConfiguration has not been defined.")
        }

        return nil
    }
    
    internal let config: BBConfiguration // Use of "let" (instead of "var") signals that this value cannot be changed.
    
    var touchCapturer: TouchCapturer?
    var keyCapturer: KeyCapturer?
    var deviceDataCapturer: DeviceDataCapturer?
    let server: ServerConnection
    let cache: Cache
    
    public init(args: BBConfiguration) {
        
        self.config = args
        
        self.server = ServerConnection(ip: args.serverIP, domainID: args.domainID, callback: args.callback)
        self.cache = Cache(server: server, size: args.cacheSize, rate: args.sendRate)
        
        if config.enabledComponents.contains(.KeyEvents) {
            self.keyCapturer = KeyCapturer(cache: self.cache)
        }
        
        if config.enabledComponents.contains(.TouchEvents) {
            self.touchCapturer = TouchCapturer(cache: self.cache)
        }
        
        if config.enabledComponents.contains(.PhoneData) {
            self.deviceDataCapturer = DeviceDataCapturer(cache: self.cache)
            self.deviceDataCapturer?.capturePhoneData()
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
    
    public func captureKeyEvent(notification: NSNotification) {
        if let keyCapt = keyCapturer {
            keyCapt.processKeyEvent(notification)
        }
    }
}