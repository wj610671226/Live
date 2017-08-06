//
//  NetWorkProtocol.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Alamofire

protocol NetWorkProtocol {}

enum Method: String {
    case get     = "GET"
    case post    = "POST"
}

extension NetWorkProtocol {
    func request(_ url: String, _ method: Method, _ param: [String: Any]?, _ success: @escaping (_ result: Any) -> Void) {
        let mod: HTTPMethod = method.rawValue == "POST" ? HTTPMethod.post : HTTPMethod.get
        Alamofire.request(url, method: mod, parameters: param).validate().responseJSON { (response) in
            guard let value = response.result.value else {
                let error = response.result.error!.localizedDescription
                print("networking error = \(error)")
                return
            }
            success(value)
        }
        
        
//        Alamofire.request("http://qf.56.com/home/v4/moreAnchor.ios", method: .post, parameters: param).validate().responseJSON { (response) in
//            
//            guard let value = response.result.value else {
//                let error = response.result.error!.localizedDescription
//                print("networking error = \(error)")
//                return
//            }
//            print(value)
//        }
    }
}
