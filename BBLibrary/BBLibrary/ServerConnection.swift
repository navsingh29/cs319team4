//
//  Uplink.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation
import SocketIOClientSwift

class ServerConnection {
    let authHandler: (BBResponse) -> ()
    let socket: SocketIOClient
    
    init(ip: String, callback: (BBResponse) -> ()) {
        self.authHandler = callback
        self.socket = SocketIOClient(socketURL: NSURL(string: ip)!, options: [.Log(true), .Secure(true)])
        
        // TODO: Remove this test code.
        self.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items)")
        }
        // END test code
        
        self.socket.connect()
    }
    
    func send(data: [DataPacket], resultHandler: (Bool) -> ()) {
        if socket.status != .Connected {
            resultHandler(false)
        } else {
            socket.emitWithAck("data", data)(timeoutAfter: 0, callback: onAck(resultHandler))
            // TODO: Handle a timeout.
        }
    }
    
    private func onAck(resultHandler: (Bool) -> ()) -> ([AnyObject]) -> () {
        return {
            response in
            print("Got ack with data: (response)")
            
            resultHandler(true)
            
            // TODO: Figure out the appropriate BBResponse.
            self.authHandler(BBResponse.Authorized)
        }
    }
}