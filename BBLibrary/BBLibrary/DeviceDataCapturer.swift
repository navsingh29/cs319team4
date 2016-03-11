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
    
    // capture and store ios version
    func captureIOSVersion(){
        let ios = UIDevice.currentDevice().systemVersion
        let iosPack = DataPacket.init(data: ["IOS: ":"\(ios)"])
        cache.store(iosPack)
        print("IOS: \(ios)")
    }
    
    //capture and store model (ipad or iphone)
    func captureModel(){
        let device = UIDevice.currentDevice().model
        let devicePack = DataPacket.init(data: ["Model: ":"\(device)"])
        cache.store(devicePack)
        print("Model: \(device)")
    }
    
    //capture and store device width and height
    func captureDeviceScreenSize(){ let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenWidthPack = DataPacket.init(data: ["ScreenWidth in points: ":"\(screenWidth)"])
        cache.store(screenWidthPack)
        print("ScreenWidth in points: \(screenWidth)")
        
        let screenHeight = screenSize.height
        let screenHeightPack = DataPacket.init(data: ["ScreenHeight in points: ":"\(screenHeight)"])
        cache.store(screenHeightPack)
        print("ScreenHeight in points: \(screenHeight)")
    }
    
    //capture and store local time zone
    func captureLocalTimeZone(){
        let ltz =  NSTimeZone.localTimeZone().name
        let ltzPack = DataPacket(data: ["TimeZone: ":ltz])
        cache.store(ltzPack)
        print("TimeZone: \(ltz)")
    }
    
    //capture and store language settings
    func captureLanguageSetting(){
        let prefferedLanguage = NSLocale.preferredLanguages()[0]
        let prefferedLanguagePack = DataPacket.init(data: ["Preffered Language: ":"\(prefferedLanguage)"])
        cache.store(prefferedLanguagePack)
        print("Preffered Language: \(prefferedLanguage)")
    }
    
}