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
    internal let config: BBConfiguration // Use of "let" (instead of "var") signals that this value cannot be changed.
    
    //var touchCapturer: TouchCapturer?
    let server: ServerConnection
    let cache: Cache
    
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
            //self.touchCapturer = TouchCapturer(cache: self.cache)
        }
        
        if config.enabledComponents.contains(.PhoneData) {
            // TODO: Initialize the Phone Data Capturer
            // Don't forget to pass the cache object to your new class.
            
            // capture and store ios version
            let ios = UIDevice.currentDevice().systemVersion
            let iosPack = DataPacket.init(data: ["IOS: ":"\(ios)"])
            cache.store(iosPack)
            
            //capture and store model (ipad or iphone)
            let device = UIDevice.currentDevice().model
            let devicePack = DataPacket.init(data: ["Model: ":"\(device)"])
            cache.store(devicePack)
            
            //capture and store device width and height
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            let screenWidthPack = DataPacket.init(data: ["ScreenWidth in points: ":"\(screenWidth)"])
            cache.store(screenWidthPack)
            let screenHeight = screenSize.height
            let screenHeightPack = DataPacket.init(data: ["ScreenHeight in points: ":"\(screenHeight)"])
            cache.store(screenHeightPack)
            
            //capture and store local time zone
            let ltz =  NSTimeZone.localTimeZone().name
            let ltzPack = DataPacket(data: ["TimeZone: ":ltz])
            cache.store(ltzPack)
            
            //capture and store language settings
            let prefferedLanguage = NSLocale.preferredLanguages()[0]
            let prefferedLanguagePack = DataPacket.init(data: ["Preffered Language: ":"\(prefferedLanguage)"])
            cache.store(prefferedLanguagePack)
        }
    }
    
    public func setUserID(userID: String) {
        self.server.setUserID(userID)
    }
    
    public func captureTouchEvent(event: UIEvent) {
        /*if let touchCapt = touchCapturer {
            touchCapt.processTouchEvent(event)
        }*/
    }
}