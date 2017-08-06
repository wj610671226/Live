//
//  LiveViewModel.swift
//  Live
//
//  Created by wangjie on 2017/7/12.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class LiveViewModel: NetWorkProtocol {
    
    private let url: String = "http://qf.56.com/play/v2/preLoading.ios"
    
    func loadLiveRoomData(_ roomid: String, _ uid: String, finshedCallBack: @escaping (_ liveUrl: String) -> ()) {
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "signature" : "f69f4d7d2feb3840f9294179cbcb913f", "roomId" : roomid, "userId" : uid]
        request(url, .get, parameters) { (response) in
            print(response)
            guard let result = response as? [String: Any] else { return }
            guard let messsage = result["message"] as? [String: Any] else { return }
            guard let rUrl = messsage["rUrl"] as? String else {
                return
            }
            
            self.loadLiveAddress(rUrl, callBack: { url in
                finshedCallBack(url)
            })
        }
    }
    
    func loadLiveAddress(_ rUrl: String, callBack: @escaping (_ url: String) -> Void) {
        request(rUrl, .get, nil) { (response) in
            guard let result = response as? [String : Any] else { return }
            guard let url = result["url"] as? String else { return }
            print(response)
            callBack(url)
        }
    }
}
