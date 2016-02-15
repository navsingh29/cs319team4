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
}

public enum BBResponse {
    case Authorized, NotAuthorized
}

public struct BBConfiguration {
    let cacheSize: Int
    let sendRate: Int
    let enabledComponents: [BBComponents]
    let callback: (BBResponse)
}

public class BBLibrary {
    private var config: BBConfiguration
    
    init(args: BBConfiguration) {
        self.config = args
    }
}