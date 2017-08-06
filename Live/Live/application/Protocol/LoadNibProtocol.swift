//
//  LoadNibProtocol.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

protocol LoadNibProtocol {}

extension LoadNibProtocol where Self: UIView {
    static func loadNibNamed(_ name: String) -> Self {
        let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.last as! Self
        return view
    }
}
