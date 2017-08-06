//
//  ClientManager.swift
//  SocketServer
//
//  Created by wangjie on 2017/7/4.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import Cocoa

class ClientManager {
    weak var delegate: ClientManagerDelegate?
    fileprivate var tcpClient: TCPClient
    fileprivate var isClientConection: Bool = false
    init(_ tcpClient: TCPClient) {
        self.tcpClient = tcpClient
    }
}

extension ClientManager {
    func read() {
        isClientConection = true
        while isClientConection {
            if let length = tcpClient.read(4) {
                // 消息长度
                let lengthData = Data(bytes: length, count: 4)
                var msgLength = 0
                (lengthData as NSData).getBytes(&msgLength, length: 4)
                print("消息长度 = \(msgLength)")
                
                
                // 消息类型
                guard let msgType = tcpClient.read(2) else {
                    return
                }

                let typeData = Data(bytes: msgType, count: 2)
                var type = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print("消息类型 = \(type)")

                // 消息
                guard let message = tcpClient.read(msgLength) else {
                    return
                }
                
                let messageData = Data(bytes: message, count: msgLength)
                let data = String.init(data: messageData, encoding: .utf8)
                print("消息 = \(data!)")
                
         
                let allData = lengthData + typeData + messageData
                delegate?.sendOtherClient(allData)
                
                
            } else {
                print("一个客户端断开了连接")
                isClientConection = false
                _ = tcpClient.close()
            }
        }
       
    }
    
    func send(data: Data) {
        tcpClient.send(data: data)
    }
}


protocol ClientManagerDelegate : class {
    func sendOtherClient(_ message: Data)
}
