//
//  ContentView.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class PageContentView: UIView {
    
    weak var delegate: PageContentViewDelegate?
    
    fileprivate var childVC: [UIViewController] // 子控制器
    fileprivate var parentVC: UIViewController // 父控制器
    fileprivate var startOffx: CGFloat = 0
    fileprivate var isClickTitle: Bool = true // 是否是点击标题，控制是否执行代理
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(self)")
        return collectionView
    }()

    init(frame: CGRect, childVC: [UIViewController], parentVC: UIViewController) {
        self.childVC = childVC
        self.parentVC = parentVC
        super.init(frame: frame)
        parentVC.automaticallyAdjustsScrollViewInsets = false
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 对外方法
extension PageContentView {
    func adjustContentOffset(currentIndex: Int) {
        let x = CGFloat(currentIndex) * KScreenWidth
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
    }
}

// MARK: - UI
extension PageContentView {
    fileprivate func initUI() {
        for vc in childVC {
            parentVC.addChildViewController(vc)
        }
        self.addSubview(collectionView)
    }
}

// MAEK: - UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(self)", for: indexPath)
        
        for item in cell.contentView.subviews {
            item.removeFromSuperview()
        }

        childVC[indexPath.item].view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC[indexPath.item].view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVC.count
    }
}


// MARK: - UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffx = scrollView.contentOffset.x
        isClickTitle = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !isClickTitle else { return }

        let offx = scrollView.contentOffset.x
        var currentIndex: Int = 0
        var progress: CGFloat = 0
        var targetIndex: Int = 0
        
        if offx > startOffx { // 左滑
            progress = offx / KScreenWidth - floor(offx / KScreenWidth)
            currentIndex = Int(offx / KScreenWidth)
            targetIndex = currentIndex + 1
            if targetIndex >= childVC.count {
                targetIndex = childVC.count - 1
            }
        } else {
            progress = 1 - (offx / KScreenWidth - floor(offx / KScreenWidth))
            targetIndex = Int(offx / KScreenWidth)
            currentIndex = targetIndex + 1
            if currentIndex >= childVC.count {
                currentIndex = childVC.count - 1
            }
        }
        
        delegate?.contentViewsetTitleViewWithProgress(currentIndex: currentIndex, targetIndex: targetIndex, progress: progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewEndScroll()
    }
    
    // 结束滚动的逻辑
    private func collectionViewEndScroll() {
        let index = Int(collectionView.contentOffset.x / KScreenWidth)
        delegate?.contentViewEndScroll(currentIndex:index)
        isClickTitle = true
    }
    
}


// MARK: - protocol - ContentViewDelegate
protocol PageContentViewDelegate: class {
    // 结束滚动
    func contentViewEndScroll(currentIndex: Int)
    // 滚动过程中
    func contentViewsetTitleViewWithProgress(currentIndex: Int, targetIndex: Int, progress: CGFloat)
}
