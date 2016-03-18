//
//  DeviceDataCapturer.swift
//  BBLibrary
//
//  Created by Anthony on 2016-03-11.
//
//

import Foundation

class DeviceDataCapturer{
    let cache: Cache
    
    init(cache: Cache){
        self.cache = cache
    }
    
    func capturePhoneData(){
        let ios = UIDevice.currentDevice().systemVersion
        let device = UIDevice.currentDevice().model
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let ltz =  NSTimeZone.localTimeZone().name
        let prefferedLanguage = NSLocale.preferredLanguages()[0]
        let phoneDataPacket = DataPacket.init(data: ["IOS": "\(ios)",
                                                     "Model": "\(device)",
                                                     "ScreenWidth in points": "\(screenWidth)",
                                                     "ScreenHeight in points": "\(screenHeight)",
                                                     "TimeZone": ltz,
                                                     "Preffered Language": "\(prefferedLanguage)"])
        cache.store(phoneDataPacket)
        print("IOS: \(ios)")
        print("Model: \(device)")
        print("ScreenWidth in points: \(screenWidth)")
        print("ScreenHeight in points: \(screenHeight)")
        print("TimeZone: \(ltz)")
        print("Preffered Language: \(prefferedLanguage)")
    }
    
}