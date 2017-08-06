//
//  GiftModel.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

struct GiftModel {
    var auth: Int = 0
    var authInfo : String = ""
    var gUrl : String = ""
    var img : String = ""
    var img2 : String = ""
    var subject : String = ""
    var coin: Int = 0
    
    
    init(_ dic: [String: Any]) {
        auth = dic["auth"] as! Int
        authInfo = dic["authInfo"] as! String
        gUrl = dic["gUrl"] as! String
        img = dic["img"] as! String
        img2 = dic["img2"] as! String
        subject = dic["subject"] as! String
        coin = dic["coin"] as! Int
    }
//    authInfo = "\U8fbe\U5230\U5c4c\U4e1d";
//    coin = 800;
//    detail = "";
//    ext =     {
//    };
//    gUrl = "https://file.qf.56.com/f/style/static/gift/pc/v2/gif/xiangshui-2.gif";
//    id = 44306;
//    img = "https://file.qf.56.com/f/style/static/gift/m/v2/thumb/xiangshui.png";
//    img2 = "https://file.qf.56.com/f/style/static/gift/m/v2/thumb/xiangshui.png";
//    isR = 0;
//    oCoin = 800;
//    pCid = 0;
//    sType =     {
//    combine = 1;
//    hit = 1;
//    };
//    subject = "\U9999\U6c34";
//    time = 3000;
//    type = 4;
//    w2Url = "https://file.qf.56.com/f/style/static/gift/m/v2/webp2/xiangshui.webp";
//    wUrl = "";
//    zUrl = "";
//    zUrl2 = "";
}
