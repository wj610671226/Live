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
    
    func request(_ url: String, _ method: Method, _ param: [String: Any]?, _ success: @escaping (_ result: Any) -> Void, _ failure: @escaping (_ error: String) -> Void) {
        let mod: HTTPMethod = method.rawValue == "POST" ? HTTPMethod.post : HTTPMethod.get
        Alamofire.request(url, method: mod, parameters: param).validate().responseJSON { (response) in
            guard let value = response.result.value else {
                let error = response.result.error!.localizedDescription
                failure(error)
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
    
    
    /**
     * 上传图片
     * @imageArray 图片数组 ["name1.jpg" : Data, "name.png": Data]
     * @serverName 服务端接收图片字段
     * @params 其他参数
     */
    func uploadImage(_ url: String, _ imageArray: [String: Data], _ serverName: String, _ params: [String: String]?, _ success: @escaping (_ result: Any) -> Void, _ failure: @escaping (_ error: String) -> Void) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in imageArray {
                let type = (key as NSString).pathExtension
                multipartFormData.append(value, withName: "\(serverName)[]",fileName: key, mimeType: "image/\(type)")
            }
            
            guard let params = params else { return }
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _):
                
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
                
                upload.responseJSON { response in
                    guard let value = response.result.value else { return }
                    success(value)
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}
