//
//  GiftModel.swift
//  GiftLabel
//
//  Created by wangjie on 2017/7/7.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class GiftContentModel: NSObject {
    
    var name: String = ""   // 送礼物的人
    var icon: String = ""
    var giftName: String = ""
    var giftUrl: String = ""

    
    override func isEqual(_ object: Any?) -> Bool {
        guard let model = object as? GiftContentModel else {
            return false
        }
        
        guard model.name == name && model.giftName == giftName else {
            return false
        }
        
        return true
    }
}
