//
//  Uplink.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation
import SocketIOClientSwift

internal class ServerConnection {
    let authHandler: (BBResponse) -> ()
    let socket: SocketIOClient
    let domainID: String
    var userID: String = ""
    
    init(ip: String, domainID: String, callback: (BBResponse) -> ()) {
        self.domainID = domainID
        self.authHandler = callback
        self.socket = SocketIOClient(socketURL: NSURL(string: ip)!, options: [.Log(true)/*, .Secure(true)*/])
        
        // TODO: Remove this test code.
        self.socket.on("connect") { data, ack in
            print("|| Socket Connected")
        }
        
        self.socket.onAny {
            print("|| Got event: \($0.event), with items: \($0.items)")
        }
        // END test code
        
        print("|| Starting server connection")
        self.socket.connect()
    }
    
    func send(data: [DataPacket], resultHandler: (Bool) -> ()) {
        if socket.status != .Connected {
            // There is no authorized user yet to send this data for. Try again once the user has logged in.
            print("|| Server is not connected");
            resultHandler(false)
        } else if userID == "" {
            // The server is not connected.
            print("|| No authorized user to send data for");
            resultHandler(false)
        } else {
            socket.emitWithAck("data", prepareDictionary(data))(timeoutAfter: 0, callback: onAck(resultHandler))
            // TODO: Handle a timeout.
        }
    }
    
    func getStatus() -> SocketIOClientStatus {
        return socket.status
    }
    
    func setUserID(userID: String) {
        self.userID = userID
    }
    
    private func prepareDictionary(packets: [DataPacket]) -> NSDictionary {
        var data = [[String:String]]();
        
        for packet in packets {
            var dat = packet.values
            dat["timestamp"] = packet.timestamp
            data.append(dat)
        }
        
        return [
            "btClientType": "ios",
            "btClientVersion": BBLibraryVersionNumber,
            "userID": userID,
            "domain": domainID,
            "data": data,
        ];
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
