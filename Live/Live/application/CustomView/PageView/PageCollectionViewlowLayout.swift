//
//  PageCollectionViewlowLayout.swift
//  Live
//
//  Created by wangjie on 2017/6/28.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class PageCollectionViewlowLayout: UICollectionViewFlowLayout {
    
    private lazy var attrArray: [UICollectionViewLayoutAttributes] = Array()
    private var maxWidth: CGFloat = 0
    var row: Int = 2 // 行
    var column: Int = 4 // 列
    
    
    override func prepare() {
        super.prepare()
        // 获取组
        let section = collectionView?.numberOfSections ?? 2
        
        let width: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(column - 1) * minimumInteritemSpacing) / CGFloat(column)
        let height: CGFloat = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(row - 1) * minimumLineSpacing) / CGFloat(row)
        
        for index in 0..<section {
            // 获取一组的cell的个数
            let cellCount: Int = collectionView!.numberOfItems(inSection: index)
            
            let pageCellCount: Int = row * column // 每页的个数

            
            for item in 0..<cellCount {
                let indexPath = IndexPath(item: item, section: index)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 先求出在第几页  item / 每页个数
                // cell 所在的位置   余数 = item % 每页个数   行号 = 余数 / 列数    列号 = 余数 % 列数
                let page: Int = item / pageCellCount // item所在页数
                let pageRemainder: Int = item % pageCellCount // 页面余数
                let rowNumber: Int = pageRemainder / column // 行号
                let columnNumber: Int = pageRemainder % column // 列号
                
                let x: CGFloat = sectionInset.left + (minimumInteritemSpacing + width) * CGFloat(columnNumber) + CGFloat(page) * collectionView!.bounds.width + maxWidth
                let y: CGFloat = sectionInset.top + (minimumLineSpacing + height) * CGFloat(rowNumber)
                attr.frame = CGRect(x: x, y: y, width: width, height: height)
                
                attrArray.append(attr)
            }
            
        
            let pageNumber: CGFloat = (cellCount % pageCellCount == 0) ? CGFloat(cellCount / pageCellCount) : CGFloat(cellCount / pageCellCount) + 1.0 // 该组的页数
            let currentSectionWidth = pageNumber * collectionView!.bounds.width
            maxWidth += currentSectionWidth
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: collectionView!.bounds.height)
    }
}
