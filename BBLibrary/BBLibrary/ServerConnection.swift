//
//  Uplink.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation

class ServerConnection {
    let callback: (BBResponse)
    
    init(ip: String, callback: (BBResponse)) {
        self.callback = callback;
    }
    
    func send(data: [DataPacket]) -> Bool {
        return false
    }
}