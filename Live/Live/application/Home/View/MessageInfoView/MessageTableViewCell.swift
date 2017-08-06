//
//  MessageTableViewCell.swift
//  Live
//
//  Created by wangjie on 2017/7/6.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}
