//
//  TitleViewStyle.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class PageTitleViewStyle {
    /// 高度
    var titleViewHeight: CGFloat = 44
    /// 字体大小
    var titleFont: CGFloat = 16
    /// 间距
    var margin : CGFloat = 10
    /// 字体颜色
    var normalColor: UIColor = UIColor.init(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1)
    var selectedColor: UIColor = UIColor.init(red: 250 / 255.0, green: 128 / 255.0, blue: 10 / 255.0, alpha: 1)
    /// 背景颜色
    var backgroundColor: UIColor = UIColor.white
    
    
    /// 是否可以滚动
    var isScroll: Bool = true
    
    /// 下划线的高度
    var bottomLineHeight: CGFloat = 2
    /// 是否需要下划线
    var isShowBottomLine: Bool = true
    
    /// 是否放大选中的标题（isScroll = true 才生效）
    var isScale: Bool = true
    /// 默认放大倍数
    var scale: CGFloat = 1.2
    
    /// 是否在顶部
    var isTop: Bool = true
    
}
