//
//  Socket.swift
//  Client
//
//  Created by wangjie on 2017/7/4.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class Socket {
    weak var delegate: SocketDelegate?
    fileprivate var tcpClient: TCPClient
    
    fileprivate lazy var userInfo: UserInfo = {
        let builder = UserInfo.Builder()
        builder.name = "张三"
        builder.iconUrl = "http://www.baidu.com"
        builder.level = 10
        return try! builder.build()
    }()
    init(_ addr: String, _ port: Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
}


extension Socket {
    func connect() -> Bool{
        return tcpClient.connect(timeout: 5).0
    }
    
    func sendMssage(data: Data, type: Int) {
        // 消息长度
        var length = data.count
        let lengthData = Data.init(bytes: &length, count: 4) // 规定长度为4
        
        // 消息类型
        var msgType = type
        let typeData = Data.init(bytes: &msgType, count: 2)
        let totleData = lengthData + typeData + data
        
        tcpClient.send(data: totleData)
    }
    
    func joinRoom() {
        let data = userInfo.data()
        sendMssage(data: data, type: 0)
    }
    
    func levelRoom() {
        let data = userInfo.data()
        sendMssage(data: data, type: 1)
    }
    
    func sendChatMessage() {
        let builder = ChatMessage.Builder()
        builder.name = "发送消息"
        builder.userInfo = userInfo
        let data = (try! builder.build()).data()
        sendMssage(data: data, type: 2)
    }
    
    func sendGiftMessage() {
        let builder = GiftMessage.Builder()
        builder.name = "小星星"
        builder.userInfo = userInfo
        builder.imgUrl = "http://www.jiankang.com/detail/198416.shtml"
        builder.imgCount = 5
        let data = (try! builder.build()).data()
        sendMssage(data: data, type: 3)
    }
    
    func sendHeartbeat()  {
        let heart: String = "sendHeartbeat"
        let data = heart.data(using: .utf8)!
        sendMssage(data: data, type: 100)
    }
    
    
    // 接收服务器发送的数据
    func reciveServerData() {
        DispatchQueue.global().async {
            while true {
                // data length
                guard let headerMessage = self.tcpClient.read(4) else {
                    return
                }
                let headerData = Data(bytes: headerMessage, count: 4)
                var length = 0
                (headerData as NSData).getBytes(&length, length: 4)
                
                // type
                guard let typeMessage = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMessage, count: 2)
                var type = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // conetent
                guard let contentMessage = self.tcpClient.read(length) else {
                    return
                }
                
                let content = Data(bytes: contentMessage, count: length)
                
                DispatchQueue.main.async {
                    self.parseReciverData(type: type, data: content)
                }
            }
        }
    }
    
    fileprivate func parseReciverData(type: Int, data: Data) {
        guard data.count != 0 else { return }
        switch type {
        case 0: // 进入房间
            let userInfo = try! UserInfo.parseFrom(data: data)
            delegate?.joinRoom(userInfo: userInfo)
        case 1: // 离开房间
            let userInfo = try! UserInfo.parseFrom(data: data)
            delegate?.leaveRoom(userInfo: userInfo)
        case 2: // 发送聊天信息
            let chatMessage = try! ChatMessage.parseFrom(data: data)
            delegate?.sendChatMessage(chatMessage: chatMessage)
        case 3: // 赠送礼物
            let giftMessage = try! GiftMessage.parseFrom(data: data)
            delegate?.sendgiftMessage(giftMessage: giftMessage)
        case 100:
            print("心跳包")
        default:
            print("无法识别的消息")
        }
    }
}


protocol SocketDelegate: class {
    func joinRoom(userInfo: UserInfo)
    func leaveRoom(userInfo: UserInfo)
    func sendChatMessage(chatMessage: ChatMessage)
    func sendgiftMessage(giftMessage: GiftMessage)
}
