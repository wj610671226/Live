//
//  EmoticonView.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class EmoticonView: UIView {
    
    var sendMessage: ((_ message: EmoticomModel) -> ())?
    fileprivate lazy var viewModel : EmoticonViewModel = EmoticonViewModel()
    fileprivate var pageCollectionView: PageCollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        let title = ["普通", "粉丝专属"]
        let style = PageTitleViewStyle()
        style.isScroll = false
        style.isScale = false
        style.isTop = false
        style.backgroundColor = UIColor(r: 37, g: 37, b: 37)
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        let layout = PageCollectionViewlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.row = 3
        layout.column = 7
        pageCollectionView = PageCollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), titles: title, titleStyle: style, layout: layout, collectionViewColor: UIColor.init(r: 75, g: 74, b: 77))
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.backgroundColor = UIColor.init(r: 75, g: 74, b: 77)
        self.addSubview(pageCollectionView)
        
        pageCollectionView.register(nib: UINib(nibName: "EmoticonCell", bundle: nil), forCellWithReuseIdentifier: "\(self)")
        
        
        viewModel.getEmoticonData { 
            self.pageCollectionView.reloadData()
        }
    }
}


extension EmoticonView: PageCollectionViewDataSource {
    func numberOfSections(in wjPageCollectionView: UICollectionView) -> Int {
        return viewModel.data.count
    }
    
    func pageCollectionView(_ wjPageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.data[section] 
        return section.count
    }
    
    func pageCollectionView(_ wjPageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wjPageCollectionView.dequeueReusableCell(withReuseIdentifier: "\(self)", for: indexPath) as! EmoticonCell
        
        cell.model = viewModel.data[indexPath.section][indexPath.item]
        
        return cell
    }
}

extension EmoticonView: PageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let message: EmoticomModel = viewModel.data[indexPath.section][indexPath.item]
        sendMessage?(message)
    }
}
