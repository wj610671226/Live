//
//  GiftContentView.swift
//  GiftLabel
//
//  Created by wangjie on 2017/7/7.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class GiftContentView: UIView {
    
    fileprivate let contentCellCount: Int = 2
    fileprivate var contentCellArray: [GiftContentCell] = Array()
    fileprivate lazy var cacheData: [GiftContentModel] = Array()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func sendGift(model: GiftContentModel) {
        // 检查是否有正在使用的cell
        if let contentCell = checkUsingContentCell(model) {
            contentCell.addOnceToCache()
            return
        }
        
        // 检查是否有空闲的cell
        if let contentCell = checkIdleContentCell() {
            contentCell.giftContentModel = model
            return
        }
        
        cacheData.append(model)
    }
}


extension GiftContentView {
    fileprivate func initUI() {
        
        let width: CGFloat = self.bounds.width
        let height: CGFloat = 40
        let x = -(self.bounds.width)
        
        for index in 0..<contentCellCount {
            let cell = GiftContentCell.loadNibNamed("GiftContentCell")
            cell.frame = CGRect(x: x, y: CGFloat(index) * height, width: width, height: height)
            self.addSubview(cell)
            contentCellArray.append(cell)
            
            
            cell.endAnimationCallBack = { cell in
                
                guard self.cacheData.count != 0 else { return }
                
                let model = self.cacheData.first!
                self.cacheData.removeFirst()

                cell.giftContentModel = model
                
                // 将缓存中相同的model数据取出
                for index in (0..<self.cacheData.count).reversed() {
                    let m = self.cacheData[index]
                    if m.isEqual(model) {
                        cell.addOnceToCache()
                        self.cacheData.remove(at: index)
                    }
                }
            }
        }
    }
    
    
    fileprivate func checkUsingContentCell(_ model: GiftContentModel) -> GiftContentCell? {
        // 判断当前是否有cell并且当前model和 传进来的model是否相同
        for cell in contentCellArray {
            if model.isEqual(cell.giftContentModel) && cell.state != .ending {
                return cell
            }
        }
        return nil
    }
    
    fileprivate func checkIdleContentCell() -> GiftContentCell? {
        for cell in contentCellArray {
            if cell.state == .idle {
                return cell
            }
        }
        return nil
    }
}
