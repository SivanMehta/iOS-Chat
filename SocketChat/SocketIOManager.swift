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
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
        // if we can connect we will receive the userList event
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        
        // if cannot connect we will receive the denyAccess event
        socket.on("denyAccess") { (data, ack) -> Void in
            completionHandler(nil)
        }
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("disconnect")
        completionHandler()
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject?
            messageDictionary["message"] = dataArray[1] as! String as AnyObject?
            messageDictionary["date"] = dataArray[2] as! String as AnyObject?
            
            completionHandler(messageDictionary)
        }
    }

    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
}
