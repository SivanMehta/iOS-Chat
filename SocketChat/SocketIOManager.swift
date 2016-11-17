//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Sivan Mehta on 11/16/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://127.0.0.1:3000")! as URL)
        
    func establishConnection() {
        print("connecting...")
        socket.connect()
    }
    
    
    func closeConnection() {
        print("disconnecting...")
        socket.disconnect()
    }
}
