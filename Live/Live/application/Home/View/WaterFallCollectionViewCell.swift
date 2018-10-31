//
//  WaterFallCollectionViewCell.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Kingfisher

class WaterFallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headerimageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    
    var model: WaterFallModel? {
        didSet {
            nameLabel.text = model?.name
            let number = model?.focus ?? 0
            numberLabel.text = String(describing: number)
//            headerimageView.kf.setImage(with: URL(string: model!.isEvenIndex ? model!.pic74 : model!.pic51), placeholder: UIImage(named: "home_pic_default"))
            
            headerimageView.kf.setImage(with: URL(string: model!.pic74), placeholder: UIImage(named: "home_pic_default"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
