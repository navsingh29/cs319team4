
//
//  Cache.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation

struct DataPacket {
    let timestamp: String
    let values: [String: String]
}

class Cache {
    let server: ServerConnection
    let cacheLimit: Int
    let bufferSize: Int
    var data = [DataPacket]()
    
    init(server: ServerConnection, size: Int, rate: Int) {
        self.server = server
        self.cacheLimit = size
        self.bufferSize = rate
    }
    
    func store(packet: DataPacket) {
        if (data.count > cacheLimit) {
            // Ignore the new data
            // TODO: Maybe we should replace old data instead.
            return
        }
        
        // Put the packet into the cache.
        data.append(packet);
        
        // Check if the buffer size has been reached.
        if (data.count >= bufferSize) {
            // Attempt to send our data
            let result = server.send(data)
            
            if (result == true) {
                // All the data has been sent, clear our cache.
                data = [DataPacket]()
            }
        }
    }
}