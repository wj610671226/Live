//
//  DiscoverViewController.swift
//  Live
//
//  Created by wangjie on 2017/9/24.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverViewController: UIViewController {

    private let manager = NetworkReachabilityManager(host: "www.baidu.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        manager?.listener = { status in
            print(status)
        }
        
        manager?.startListening()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
