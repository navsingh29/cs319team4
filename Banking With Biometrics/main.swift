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

let serverIP = "ws://btdemo.plurilock.com:8095" //"http://localhost:8080" //"ws://echo.websocket.org"

func authCallback(response: BBResponse) {
    if response == .NotAuthorized {
        let delegate = BBApplication.sharedApplication().delegate!
        
        let storyboard: UIStoryboard = delegate.window!!.rootViewController!.storyboard!
        let firstViewController: UIViewController = storyboard.instantiateInitialViewController()!
        delegate.window!!.rootViewController = firstViewController
        
        let alert: UIAlertController = UIAlertController(title: "You have been logged out", message: "Suspicious activity was detected. Please enter you credentials and log in again to continue.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        firstViewController.presentViewController(alert, animated: true, completion: nil)
        
        print("User is not authorized")
    }
}

let config = BBConfiguration(serverIP: serverIP, domainID: "testDomainT4", cacheSize: 1024, sendRate: 10, enabledComponents: BBComponents.allValues, digraphTimeout: 300, callback: authCallback)

BBLibrary.configure(config)

UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(BBApplication), NSStringFromClass(AppDelegate))