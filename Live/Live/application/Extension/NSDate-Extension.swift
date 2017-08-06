//
//  NSDate-Extension.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import Foundation


extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
