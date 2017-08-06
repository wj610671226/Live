//
//  HomeTypeModel.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

struct HomeTypeModel {
    var title: String = "" // 标题
    var type: Int = 0 // 类型
    
    init(_ dic: [String: Any]) {
        title = dic["title"] as! String
        type = dic["type"] as! Int
    }
}
