//
//  BBLibrary.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation

public enum BBComponents {
    case KeyEvents, TouchEvents, PhoneData
    static let allValues = [KeyEvents, TouchEvents, PhoneData]
}

public enum BBResponse {
    case Authorized, NotAuthorized
}

public struct BBConfiguration {
    let serverIP: String
    let cacheSize: Int
    let sendRate: Int
    let enabledComponents: [BBComponents]
    let callback: (BBResponse) -> ()
    //let touchListener // TODO: Implement some object that we can listen to for touches.
}

public class BBLibrary {
    internal let config: BBConfiguration // Use of "let" (instead of "var") signals that this value cannot be changed.
    
    public init(args: BBConfiguration) {
        self.config = args
        
        let uplink = ServerConnection(ip: args.serverIP, callback: args.callback)
        let cache = Cache(server: uplink, size: args.cacheSize, rate: args.sendRate)
        
        // Initialize all data capturers.
        for component in BBComponents.allValues {
            // For example:
            // DataCapturer(cache)
        }
    }
}