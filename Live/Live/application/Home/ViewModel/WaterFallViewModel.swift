//
//  WaterFallViewModel.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class WaterFallViewModel : NetWorkProtocol {
    
    lazy var data: [WaterFallModel] = Array()
    private let url: String = "http://qf.56.com/home/v4/moreAnchor.ios"
    
    
    func loadWaterFallData(_ type: Int, _ index: Int, _ success: @escaping () -> (),_ failure: @escaping (_ error: String) -> ()) {
        
        let param = ["type" : type, "index" : index, "size" : 48]
        request(url, .post, param, { (response) in

            print(response)
            
            guard let result = response as? [String: Any] else { return }
            guard let message = result["message"] as? [String : Any] else { return }
            guard let anchors = message["anchors"] as? [Any] else {
                return
                
            }

            if anchors.count == 0 {
                failure("获取的数据为空")
                return
            }
            
            for (index, obj) in anchors.enumerated() {
                var model = WaterFallModel(obj as! [String : Any])
                model.isEvenIndex = index % 2 == 0
                self.data.append(model)
            }
            
            success()
        }) { (error) in
            failure(error)
        }
    }
}
