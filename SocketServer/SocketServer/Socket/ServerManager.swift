//
//  ServerManager.swift
//  SocketServer
//
//  Created by wangjie on 2017/7/4.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import Cocoa

class ServerManager {
    fileprivate var serverManager: TCPServer = TCPServer(addr: "0.0.0.0", port: 8989)
    
    fileprivate var isRuningServer: Bool = false
    
    fileprivate var managerArray: [ClientManager]  = Array()
}

extension ServerManager {
    func starterver() {
        serverManager.listen()
        
        isRuningServer = true
        
        DispatchQueue.global().async {
            while self.isRuningServer {
                if let client = self.serverManager.accept() {
                    DispatchQueue.global().async {
                        self.handlerClient(client)
                    }
                }
            }
        }
    }
    
    
    func stopServer() {
        isRuningServer = false
    }
    
    fileprivate func handlerClient(_ client: TCPClient)  {
        let tcpManager = ClientManager(client)
        managerArray.append(tcpManager)
        tcpManager.delegate = self
        tcpManager.read()
    }
}


extension ServerManager: ClientManagerDelegate {
    func sendOtherClient(_ message: Data) {
        for item in managerArray {
            item.send(data: message)
        }
    }
}
