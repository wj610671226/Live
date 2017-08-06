//
//  EmitterProtocol.swift
//  Live
//
//  Created by wangjie on 2017/6/29.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

protocol EmitterProtocol { }

extension EmitterProtocol where Self: UIViewController {
    
    func createEmitterAnimation(_ point: CGPoint, _ emitterCellImages: [String]) {
        let emitterLayer = CAEmitterLayer()
        // 发射器位置
        emitterLayer.emitterPosition = point
        emitterLayer.preservesDepth = true // 开启三维效果
        var cellArray: [CAEmitterCell] = Array()
        
        for index in 0..<emitterCellImages.count {
            
            let cell = CAEmitterCell()
            cell.birthRate = 1 // 每秒发出多少个粒子
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            cell.scale = 0.6
            cell.scaleRange = 0.4
            
            // 设置粒子的方向
            cell.emissionLongitude = .pi * 3 / 2
            cell.emissionRange = .pi / 9
            
            // 设置粒子的速度
            cell.velocity = 50
            cell.velocityRange = 20
            
            // 设置粒子旋转
//            cell.spin = .pi / 2
//            cell.spinRange = .pi / 2
            
            // 设置粒子的内容
            cell.contents = UIImage(named: emitterCellImages[index])?.cgImage
            
            cellArray.append(cell)
        }
        
        
        // 将粒子设置到发射器中
        emitterLayer.emitterCells = cellArray
        
        // 将layer添加到父layer中
        view.layer.addSublayer(emitterLayer)
    }
    
    func stopEmitterAnimation() {
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}
