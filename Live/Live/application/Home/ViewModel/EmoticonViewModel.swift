//
//  EmoticonViewModel.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

struct EmoticonViewModel {
    
    var data: [[EmoticomModel]] = Array()
    
    mutating func getEmoticonData(_ loadDataFinshed: () -> ()) {
        initData("QHNormalEmotionSort", "plist")
        initData("QHSohuGifSort", "plist")
        
        loadDataFinshed()
    }
    
    private mutating func initData(_ resource: String, _ type: String) {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else { return }
        guard let normalData = NSArray(contentsOfFile: path) as? [String] else { return }
        var array: [EmoticomModel] = Array()
        for item in normalData {
            let model = EmoticomModel(item)
            array.append(model)
        }
        data.append(array)
    }
}
