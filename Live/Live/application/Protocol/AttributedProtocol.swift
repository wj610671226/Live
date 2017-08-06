//
//  AttributedProtocol.swift
//  Live
//
//  Created by wangjie on 2017/7/6.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Kingfisher

protocol AttributedProtocol {}


extension AttributedProtocol {
    func createRoomAttributeString(_ userName: String, _ isJoin: Bool) -> NSAttributedString {
        let sourcesString = "\(userName) " + (isJoin ? "进入房间" : "离开房间")
        let attr = NSMutableAttributedString(string: sourcesString)
        attr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        return attr
    }
    
    func createChatAttributeString(_ userName: String, _ chatText: String) -> NSAttributedString {
        let sourcesString = "\(userName): \(chatText)"
        let attr = NSMutableAttributedString(string: sourcesString)
        // chatText = "sdsf[笑脸]，sds[开心]"
        
        // 颜色
        attr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        // 表情
        let pattern = "\\[.*?\\]"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return attr}
        
        let result = regex.matches(in: sourcesString, options: [], range: NSRange(location: 0, length: sourcesString.characters.count))
        
        for index in (0..<result.count).reversed() {
            let range = result[index].range
            
            let imageString = (sourcesString as NSString).substring(with: range)
            // 生成图片
            guard let image = UIImage(named: imageString) else { continue }
            
            let ment = NSTextAttachment()
            ment.image = image
            let font = UIFont.systemFont(ofSize: 14)
            ment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let attrImage = NSAttributedString(attachment: ment)
            attr.replaceCharacters(in: range, with: attrImage)
        }

        return attr
    }
    
    
    func createGiftAttributeString(_ userName: String, _ giftName: String, _ giftUrl: String) -> NSAttributedString {
        let sourcesString = "\(userName) 赠送了 \(giftName)"
        let attr = NSMutableAttributedString(string: sourcesString)
        
        // 用户姓名颜色
        attr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        
        // 礼物名称
        let giftNameRange = (sourcesString as NSString).range(of: giftName)
        attr.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: giftNameRange)
        
        // 图片
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftUrl) else {
            return attr
        }
        let ment = NSTextAttachment()
        ment.image = image
        let font = UIFont.systemFont(ofSize: 14)
        ment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let attrImage = NSAttributedString(attachment: ment)
        attr.append(attrImage)
        
        return attr
    }
}
