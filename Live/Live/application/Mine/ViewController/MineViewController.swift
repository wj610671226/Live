//
//  MineViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let title = ["热门", "高级", "豪华", "专属"]
        let style = PageTitleViewStyle()
        style.isScroll = false
        style.isScale = false
//        style.isTop = false
        let layout = PageCollectionViewlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let pageCollectionView = PageCollectionView(frame: CGRect(x: 0, y: 100, width: KScreenWidth, height: 200), titles: title, titleStyle: style, layout: layout)
        view.addSubview(pageCollectionView)
        pageCollectionView.dataSource = self
        pageCollectionView.register(cellClass: UICollectionViewCell.self, forCellWithReuseIdentifier: "\(self)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MineViewController: PageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: UICollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 1 {
            return 15
        } else if section == 3 {
            return 22
        } else {
            return 6
        }
    }
    
    func pageCollectionView(_ pageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: "\(self)", for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

