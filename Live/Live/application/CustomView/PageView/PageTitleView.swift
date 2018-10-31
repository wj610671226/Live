//
//  TitleView.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit


protocol PageTitleViewDelegate: class {
    func clickTilteView(currentIndex : Int)
}

class PageTitleView: UIView {

    weak var delegate: PageTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: PageTitleViewStyle
    // 存放lable
    fileprivate var labels: [UILabel] = Array()
    // 上次点击的label
    fileprivate var lastLabel: UILabel!

    
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.normalColor)
    
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.selectedColor
        return bottomLine
    }()
    
    init(frame: CGRect, titles: [String], style: PageTitleViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        initUI()
        self.backgroundColor = style.backgroundColor
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("销毁")
    }
}


// MARK: - 设置UI
extension PageTitleView {
    fileprivate func initUI() {
        
        // scrollview 
        self.addSubview(scrollView)
    
        // label
        initLable()
        
        // 下滑线
        addBottomLine()
    }
    
    fileprivate func initLable() {
        guard titles.count > 0 else { fatalError("title 不能为空") }
        
        if style.isScroll { // 可以滚动
            let size = CGSize(width: CGFloat(MAXFLOAT), height: style.titleViewHeight)
            for item in titles {
                let width = (item as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: style.titleFont)], context: nil).width
                let x = labels.last?.frame.maxX ?? 0
                let label = UILabel(frame: CGRect(x: x + style.margin, y: 0, width: width, height: style.titleViewHeight))
                label.text = item
                labels.append(label)
            }
        } else {
            let width: CGFloat = KScreenWidth / CGFloat(titles.count)
            for item in titles {
                let x = labels.last?.frame.maxX ?? 0
                let label = UILabel(frame: CGRect(x: x, y: 0, width: width, height: style.titleViewHeight))
                label.text = item
                labels.append(label)
            }
        }
        
        for (index,label) in labels.enumerated(){
            label.tag = index
            label.font = UIFont.systemFont(ofSize: style.titleFont)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.textColor = style.normalColor
            scrollView.addSubview(label)
            // 添加点击手势
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PageTitleView.clickTitleItem)))
        }
        
        let width = labels.last?.frame.maxX ?? 0
        scrollView.contentSize = style.isScroll ? CGSize(width: width + style.margin, height: style.titleViewHeight) : CGSize.zero
        
        
        lastLabel = labels.first
        if style.isScale && style.isScroll {
            lastLabel.transform = CGAffineTransform.init(scaleX: style.scale, y: style.scale)
        }
        lastLabel.textColor = style.selectedColor
    }
    
    
    fileprivate func addBottomLine() {
        guard style.isShowBottomLine else { return }
        
        scrollView.addSubview(bottomLine)
        
        var width: CGFloat = 0
        var x: CGFloat = 0
        let y: CGFloat = style.titleViewHeight - style.bottomLineHeight
        if style.isScroll { // 滚动
            let size = CGSize(width: CGFloat(MAXFLOAT), height: style.titleViewHeight)
            width = (titles.first! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: style.titleFont)], context: nil).width
            x = labels.first?.frame.minX ?? 0
        } else {
            width = KScreenWidth / CGFloat(titles.count)
        }
        
        bottomLine.frame = CGRect(x: x, y: y, width: width, height: style.bottomLineHeight)
    }
    
    
}

//MARK: - selector
extension PageTitleView {
    // 点击标题
    @objc fileprivate func clickTitleItem(sender: UITapGestureRecognizer) {
        let currentLabel = sender.view as! UILabel
        guard currentLabel.tag != lastLabel.tag else { return }
        
        self.delegate?.clickTilteView(currentIndex: currentLabel.tag)
        
        lastLabel.textColor = style.normalColor
        currentLabel.textColor = style.selectedColor
        // 调整titleLable postion
        scrollTitleLableToCenter(currentLabel: currentLabel)
        // 放大label
        if style.isScale {
            currentLabel.transform = CGAffineTransform(scaleX: style.scale, y: style.scale)
            lastLabel.transform = CGAffineTransform.identity
        }
        
        // 调整bottomline
        scrollBottomLine(currentIndex: currentLabel.tag, lastIndex: lastLabel.tag)
        lastLabel = currentLabel
    }
}

// MARK: - 内部逻辑处理
extension PageTitleView {
    fileprivate func scrollTitleLableToCenter(currentLabel: UILabel) {
        guard style.isScroll else { return }
        
        var offx: CGFloat = currentLabel.center.x - KScreenWidth / 2
        if offx < 0 {
            offx = 0
        }
        let maxWidth = scrollView.contentSize.width - KScreenWidth
        if offx > maxWidth {
            offx = maxWidth
        }
        scrollView.setContentOffset(CGPoint(x: offx, y: 0), animated: true)
    }
    
    
    fileprivate func scrollBottomLine(currentIndex: Int, lastIndex: Int) {
        guard style.isShowBottomLine else { return }
        UIView.animate(withDuration: 0.15, animations: {
            self.bottomLine.frame.origin.x = self.labels[currentIndex].frame.origin.x
            self.bottomLine.frame.size.width = self.labels[currentIndex].frame.size.width
        })
    }
    
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        
        let components = color.cgColor.components!
        
        guard components.count == 4 else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

// MARK: - 暴露的方法
extension PageTitleView {
    func adjustTitleLablePostion(index: Int) {
        let currentLabel = labels[index]
        // 调整titleLable postion
        scrollTitleLableToCenter(currentLabel: currentLabel)
        // 调整bottomline
        scrollBottomLine(currentIndex: currentLabel.tag, lastIndex: lastLabel.tag)
        lastLabel = currentLabel
    }
    
    // 根据progress调整label 和 bottomLine
    func adjustTitleViewWithProgress(currentIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        guard currentIndex != targetIndex else { return }
        
        let currentLable = labels[currentIndex]
        let targetLable = labels[targetIndex]
        
        lastLabel = targetLable
   
        // 颜色变化
        let difR = (selectedColorRGB.r - normalColorRGB.r) * progress
        let difG = (selectedColorRGB.g - normalColorRGB.g) * progress
        let difB = (selectedColorRGB.b - normalColorRGB.b) * progress
        
        currentLable.textColor = UIColor.init(red: (selectedColorRGB.r - difR) / 255.0, green: (selectedColorRGB.g - difG) / 255.0, blue: (selectedColorRGB.b - difB) / 255.0, alpha: 1)
        targetLable.textColor = UIColor.init(red: (normalColorRGB.r + difR) / 255.0, green: (normalColorRGB.g + difG) / 255.0, blue: (normalColorRGB.b + difB) / 255.0, alpha: 1)

        // bottomLine
        guard style.isShowBottomLine else { return }
        let difx = labels[targetIndex].frame.origin.x - labels[currentIndex].frame.origin.x
        let difWidth = labels[targetIndex].frame.size.width - labels[currentIndex].frame.size.width
        bottomLine.frame.origin.x = difx * progress + labels[currentIndex].frame.origin.x
        bottomLine.frame.size.width = difWidth * progress + labels[currentIndex].frame.size.width
        
        // 字体放大
        guard style.isScroll && style.isScale else { return }
        let scaleRange = (style.scale - 1.0) * progress
        currentLable.transform = CGAffineTransform(scaleX: style.scale - scaleRange, y: style.scale - scaleRange)
        targetLable.transform = CGAffineTransform(scaleX: 1.0 + scaleRange, y: 1.0 + scaleRange)
    }
}
