//
//  GiftViewCell.swift
//  Live
//
//  Created by wangjie on 2017/7/3.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class GiftViewCell: UICollectionViewCell {

    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var model: GiftModel? {
        didSet {
            giftImageView.kf.setImage(with: URL(string: model!.img), placeholder: UIImage(named: "room_btn_gift"))
            nameLabel.text = model?.subject
            priceLabel.text = "\(model?.coin ?? 0)"
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            if isSelected {
                giftImageView.kf.setImage(with: URL(string: model!.gUrl), placeholder: UIImage(named: "room_btn_gift"))
            } else {
                giftImageView.kf.setImage(with: URL(string: model!.img), placeholder: UIImage(named: "room_btn_gift"))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.backgroundColor = UIColor.black
        
        selectedBackgroundView = selectedView
    }

    
}
