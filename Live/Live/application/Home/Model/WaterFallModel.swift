//
//  WaterFallModel.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

struct WaterFallModel {
    var roomid : String = ""
    var name : String = ""
    var pic51 : String = ""
    var pic74 : String = ""
    var live : Int = 0 // 是否在直播
    var push : Int = 0 // 直播显示方式
    var focus : Int = 0 // 关注数
    var uid: String = ""
    
    var isEvenIndex : Bool = false
    
    init(_ dic: [String: Any]) {
        roomid = dic["roomid"] as! String
        name = dic["name"] as! String
        pic51 = dic["pic51"] as! String
        pic74 = dic["pic74"] as! String
        live = dic["live"] as! Int
        push = dic["push"] as! Int
        focus = dic["focus"] as! Int
    }
}
