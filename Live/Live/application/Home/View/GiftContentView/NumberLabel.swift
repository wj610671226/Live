//
//  NumberLabel.swift
//  GiftLabel
//
//  Created by wangjie on 2017/7/7.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class NumberLabel: UILabel {
    override func drawText(in rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(5)
        context?.setLineJoin(.round) // 圆角
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    
    // lable 动画
    func startNumberAnimation(_ callBack: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
            
        }) { (isFinshed) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinshed) in
                callBack()
            })
        }
    }
}
