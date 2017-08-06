//
//  GiftViewModel.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class GiftViewModel: NetWorkProtocol {

    // http://qf.56.com/pay/v4/giftList.ios?type=0&page=1&rows=150
    
    lazy var giftData: [[GiftModel]] = Array()
    
    private let url: String = "http://qf.56.com/pay/v4/giftList.ios"

    func loadGifterData(finshedCallBack: @escaping () -> ()) {
        
        let param = ["type" : 0, "page" : 1, "rows" : 150]
        request(url, .get, param) { (response) in
            
//            print(response)
            
            guard let result = response as? [String: Any] else { return }
            guard let message = result["message"] as? [String : Any] else { return }

            for item in message {
                guard let value = item.value as? [String : Any] else { return }
                guard let list = value["list"] as? [Any]  else { return }
                if list.count > 0 {
                    var objArray: [GiftModel] = Array()
                    for obj in list {
                        let model = GiftModel(obj as! [String : Any])
                        objArray.append(model)
                    }
                    self.giftData.append(objArray)
                }
            }

            finshedCallBack()
        }
    }
}
