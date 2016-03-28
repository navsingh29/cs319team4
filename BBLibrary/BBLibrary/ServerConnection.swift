//
//  Uplink.swift
//  BBLibrary
//
//  Created by Devindra Payment on 2016-02-15.
//
//

import Foundation
import Starscream

internal class ServerConnection : WebSocketDelegate {
    let authHandler: (BBResponse) -> ()
    let socket: Starscream.WebSocket
    let domainID: String
    var userID: String = ""
    
    var testCallback: (String, AnyObject?) -> () = {_ in}
    
    init() {
        // This is for testing purposes
        self.authHandler = {_ in}
        self.domainID = ""
        self.socket = WebSocket(url: NSURL())
    }
    
    init(ip: String, domainID: String, callback: (BBResponse) -> ()) {
        self.domainID = domainID
        self.authHandler = callback
        
        socket = WebSocket(url: NSURL(string: ip)!)
        socket.delegate = self
        print("|| Starting server connection")
        socket.connect()
        
        /*self.socket = SocketIOClient(socketURL: NSURL(string: ip)!, options: [/*.Log(true), .Secure(true)*/])
        
        // TODO: Remove this test code.
        self.socket.on("connect") { data, ack in
            print("|| Socket Connected")
        }
        
        self.socket.onAny {
            print("|| Got event: \($0.event), with items: \($0.items)")
        }
        // END test code
        
        print("|| Starting server connection")
        self.socket.connect()*/
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("|| Websocket is connected")
        testCallback("connect", nil)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("|| Websocket is disconnected: \(error?.localizedDescription)")
        testCallback("disconnect", nil)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("|| Got some text: \(text)")
        testCallback("message", text)
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("|| Got some data: \(data.length)")
        testCallback("data", data)
    }
    
    func setTestCallback(callback: (String, AnyObject?) -> ()) {
        self.testCallback = callback
    }
    
    func send(data: [DataPacket], resultHandler: (Bool) -> ()) {
        if !socket.isConnected {
            // There is no authorized user yet to send this data for. Try again once the user has logged in.
            print("|| Server is not connected")
            resultHandler(false)
        } else if userID == "" {
            // The server is not connected.
            print("|| No authorized user to send data for")
            resultHandler(false)
        } else {
            do {
                let jsonDict = prepareDictionary(data);
                let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions(rawValue: 0))
                let jsonText = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            
                print("|| Sending data with url /api/users/ios_"+(jsonDict["userID"] as! String)+"_"+(jsonDict["domain"] as! String));
                socket.writeString(jsonText as! String)
                resultHandler(true)
                
                // TODO: For the moment true is being sent immediately, but ideally this should only be sent when writeString succeeds.
            } catch {
                resultHandler(false)
            }
        }
    }
    
    func isConnected() -> Bool {
        return socket.isConnected
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
            
            let responseArr = (response[0] as! String).componentsSeparatedByString("$")
            
            if responseArr[1] == "Ack" {
                self.authHandler(BBResponse.Authorized)
            } else if responseArr[1] == "lock" {
                self.authHandler(BBResponse.NotAuthorized)
            } else {
                self.authHandler(BBResponse.Unrecognized)
            }
        }
    }
}
