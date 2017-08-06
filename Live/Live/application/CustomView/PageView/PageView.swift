//
//  PageView.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class PageView: UIView {

    fileprivate var titles: [String] // 标题
    fileprivate var titleStyle : PageTitleViewStyle // 标题样式
    fileprivate var childVC: [UIViewController] // 子控制器
    fileprivate var parentVC: UIViewController // 父控制器
    fileprivate var titleView: PageTitleView!
    fileprivate var contentView: PageContentView!
    
    init(frame: CGRect, titles: [String], titleStyle: PageTitleViewStyle, childVC: [UIViewController], parentVC: UIViewController) {
        self.titles = titles
        self.titleStyle = titleStyle
        self.childVC = childVC
        self.parentVC = parentVC
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - UI 
extension PageView {
    fileprivate func initUI() {
        // titleView
        titleView = PageTitleView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: titleStyle.titleViewHeight), titles: titles, style: titleStyle)
        titleView.delegate = self
        self.addSubview(titleView)

        // contentView 
        contentView = PageContentView(frame: CGRect(x: 0, y: titleStyle.titleViewHeight, width: KScreenWidth, height: self.bounds.height - titleStyle.titleViewHeight), childVC: childVC, parentVC: parentVC)
        contentView.delegate = self
        self.addSubview(contentView)
    }
}

// MARK: - TitleViewDelegate
extension PageView : PageTitleViewDelegate {
    func clickTilteView(currentIndex: Int) {
        contentView.adjustContentOffset(currentIndex: currentIndex)
    }
}

// MARK: - PageContentViewDelegate
extension PageView: PageContentViewDelegate {
    func contentViewsetTitleViewWithProgress(currentIndex: Int, targetIndex: Int, progress: CGFloat) {
        titleView.adjustTitleViewWithProgress(currentIndex: currentIndex, targetIndex: targetIndex, progress: progress)
    }

    func contentViewEndScroll(currentIndex: Int) {
        titleView.adjustTitleLablePostion(index: currentIndex)
    }

}
