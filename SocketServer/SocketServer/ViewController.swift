//
//  ViewController.swift
//  SocketServer
//
//  Created by wangjie on 2017/7/4.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var messageLabel: NSTextField!
    private let manager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @IBAction func startButton(_ sender: NSButton) {
        manager.starterver()
        messageLabel.stringValue = "服务器已经开启"
        
    }
    
    @IBAction func closeButton(_ sender: NSButton) {
        manager.stopServer()
        messageLabel.stringValue = "服务器已经关闭"
    }

}

