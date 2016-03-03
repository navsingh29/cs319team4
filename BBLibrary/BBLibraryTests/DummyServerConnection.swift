//
//  DummyServerConnection.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-03-03.
//
//

@testable import BBLibrary

class DummyServerConnection: ServerConnection {
    
    override init() {
        super.init()
    }
    
    override func send(data: [DataPacket], resultHandler: (Bool) -> ()) {
        if userID == "" {
            // The server is not connected.
            print("|| No authorized user to send data for.")
            resultHandler(false)
        } else {
            resultHandler(true)
        }
    }
    
}