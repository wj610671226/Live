//
//  PageCollectionView.swift
//  Live
//
//  Created by wangjie on 2017/6/27.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class PageCollectionView: UIView {
    
    weak var dataSource: PageCollectionViewDataSource?
    weak var delegate: PageCollectionViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var titleStyle: PageTitleViewStyle
    fileprivate var layout: PageCollectionViewlowLayout
    fileprivate var collectionView: UICollectionView!
    fileprivate var titleView: PageTitleView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var lastSection: Int = 0
    fileprivate var collectionViewBackgroundColor: UIColor!
    
    init(frame: CGRect, titles: [String], titleStyle: PageTitleViewStyle, layout: PageCollectionViewlowLayout, collectionViewColor: UIColor = UIColor.black) {
        self.titles = titles
        self.titleStyle = titleStyle
        self.layout = layout
        self.collectionViewBackgroundColor = collectionViewColor
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageCollectionView {
    fileprivate func initUI() {
        // titleView
        let y: CGFloat = titleStyle.isTop ? 0 : (bounds.height - titleStyle.titleViewHeight)
        let frame = CGRect(x: 0, y: y, width: bounds.width, height: titleStyle.titleViewHeight)
        titleView = PageTitleView(frame: frame, titles: titles, style: titleStyle)
        titleView.delegate = self
        self.addSubview(titleView)
        
        // pageControllView
        let pageH: CGFloat = 10
        let pageY: CGFloat = titleStyle.isTop ? bounds.height - pageH : bounds.height - pageH - titleStyle.titleViewHeight
        pageControl = UIPageControl(frame: CGRect(x: 0, y: pageY, width: bounds.width, height: pageH))
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = UIColor(r: 108, g: 106, b: 109)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(pageControl)
        
        // collectionView
        layout.scrollDirection = .horizontal
        let collectionH: CGFloat = bounds.height - titleStyle.titleViewHeight - pageH
        let collectionY: CGFloat = titleStyle.isTop ? titleStyle.titleViewHeight : 0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: collectionY, width: bounds.width, height: collectionH), collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = collectionViewBackgroundColor
        self.addSubview(collectionView)
    }
    
    
    fileprivate func collectionViewEndScroll() {
        guard let cell = collectionView.visibleCells.first else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let section = indexPath.section
        
        if lastSection != section {
            // pageControl
            let itemCount = collectionView.numberOfItems(inSection: section)
            pageControl.numberOfPages = (itemCount - 1) / (layout.row * layout.column) + 1
            // titleView
            titleView.adjustTitleViewWithProgress(currentIndex: lastSection, targetIndex: section, progress: 1.0)
            
            lastSection = section
        }
        
        pageControl.currentPage = indexPath.item / (layout.row * layout.column)
    }
}


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension PageCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in:collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageCollectionView(collectionView,numberOfItemsInSection:section) ?? 0
        
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.row * layout.column) + 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dataSource!.pageCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewEndScroll()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension PageCollectionView {
    func register(cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension PageCollectionView: PageTitleViewDelegate {
    func clickTilteView(currentIndex: Int) {
        
        let indexPath = IndexPath(item: 0, section: currentIndex)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
 
        let itemCount = collectionView.numberOfItems(inSection: currentIndex)
        pageControl.numberOfPages = (itemCount - 1) / (layout.row * layout.column) + 1

        lastSection = currentIndex
    }
}

// MARK: - PageCollectionViewDataSource
protocol PageCollectionViewDataSource: class {
    func numberOfSections(in pageCollectionView: UICollectionView) -> Int
    func pageCollectionView(_ pageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

// MARK: - PageCollectionViewDelegate
protocol PageCollectionViewDelegate: class {
    func pageCollectionView(_ pageCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
