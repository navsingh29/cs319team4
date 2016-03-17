//
//  Main.swift
//  Banking With Biometrics
//
//  Created by Jun on 2016-03-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//
//
import Foundation
import UIKit
import BBLibrary

//let serverIP = "ws://echo.websocket.org"
let serverIP = "ws://btdemo.plurilock.com:8095"
//let serverIP = "http://localhost:8080"

let config = BBConfiguration(serverIP: serverIP, domainID: "testDomainT4", cacheSize: 1024, sendRate: 10, enabledComponents: [.KeyEvents, .TouchEvents,.PhoneData], callback: {_ in})

BBLibrary.configure(config)

UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(BBApplication), NSStringFromClass(AppDelegate))