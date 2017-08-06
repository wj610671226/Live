//
//  GiftContentCell.swift
//  GiftLabel
//
//  Created by wangjie on 2017/7/7.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Kingfisher

enum States {  // GiftContentCell的状态
    case idle   // 闲置状态
    case animating
    case willEnd
    case ending
}

class GiftContentCell: UIView, LoadNibProtocol {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var giftLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var numberLabel: NumberLabel!
    
    var state: States = .idle
    var endAnimationCallBack: ((_ cell: GiftContentCell) -> Void)?
    
    fileprivate var cacheNumber: Int = 0
    fileprivate var currentNumber: Int = 0
    
    
    var giftContentModel: GiftContentModel? {
        didSet {
            guard let model = giftContentModel else { return }
            
            iconImageView.image = UIImage(named: "icon1")
//            iconImageView.kf.setImage(with: URL(string: model.icon))
            nameLabel.text = model.name
            giftLabel.text = "赠送礼物:【\(model.giftName)】"
//            giftImageView.image = UIImage(named: model.giftUrl)
            giftImageView.kf.setImage(with: URL(string: model.giftUrl))
            
            state = .animating
            showContentCellAnimation()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = self.bounds.height / 2
        
        self.layer.cornerRadius = self.bounds.height / 2
    }
    

}


extension GiftContentCell {
    // 显示 ContentCell
    fileprivate func showContentCellAnimation() {
        self.alpha = 1
        self.numberLabel.text = " x1 "
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = 0
        }) { (isFinshed) in
            self.showNumberLableAnimation()
        }
    }
    
    fileprivate func showNumberLableAnimation() {
        
        currentNumber += 1
        
        self.numberLabel.text = " x\(currentNumber) "
        
        UIView.animate(withDuration: 0.25) { 
            self.numberLabel.startNumberAnimation {
                if self.cacheNumber > 0 {
                    self.cacheNumber -= 1
                    self.showNumberLableAnimation()
                } else {
                    self.state = .willEnd
                    self.perform(#selector(self.endingAnimation), with: self, afterDelay: 2.0)
                }
                
            }
        }
    }
    
    @objc fileprivate func endingAnimation() {
        state = .ending
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = KScreenWidth
            self.alpha = 0
        }) { (isfinshed) in
            self.frame.origin.x = -(self.bounds.width + 50)
            self.state = .idle
            self.giftContentModel = nil
            self.currentNumber = 0
            
            self.endAnimationCallBack?(self)
        }
    }
    
    
    func addOnceToCache() {
        if state == .willEnd {
            showNumberLableAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
    }
}
