//
//  EmoticonCell.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {

    @IBOutlet weak var emoticonImageView: UIImageView!
    
    var model: EmoticomModel? {
        didSet {
            emoticonImageView.image = UIImage(named: model!.name)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
