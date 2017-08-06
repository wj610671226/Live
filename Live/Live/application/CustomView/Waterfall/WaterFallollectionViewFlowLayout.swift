//
//  WaterFallollectionViewFlowLayout.swift
//  Live
//
//  Created by wangjie on 2017/6/22.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class WaterFallCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: WaterFallCollectionViewFlowLayoutDatasource?
    
    // 存放 UICollectionViewLayoutAttributes
    private lazy var attrArray: [UICollectionViewLayoutAttributes] = Array()
    // 记录当前cell高度
    private lazy var currentHeigthArray: [CGFloat] = Array.init(repeating: self.sectionInset.top, count: Int(self.column))
    // 列数
    private lazy var column: CGFloat = {
        let col = self.delegate?.numberOfColumn(self) ?? 2
        return CGFloat(col)
    }()
    
    // 计算起始位置
    private var startIndex: Int = 0
    

    override func prepare() {
        super.prepare()
        // 获取cell的个数  默认只有一组
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 3
        let width: CGFloat = (KScreenWidth - sectionInset.left - sectionInset.right - (column - 1.0) * minimumInteritemSpacing ) / column
        for index in startIndex..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let minH = currentHeigthArray.min()!
            let minCellIndex = currentHeigthArray.index(of: minH)!
            let x: CGFloat = sectionInset.left + CGFloat(minCellIndex) * (width + minimumInteritemSpacing)
            let y: CGFloat = minH
            let height: CGFloat = delegate!.waterFallLayout(self, indexPath)
            attr.frame = CGRect(x: x, y: y, width: width, height: height)
            currentHeigthArray[minCellIndex] = minH + height + minimumLineSpacing
            attrArray.append(attr)
        }
        
        startIndex = itemCount
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: currentHeigthArray.max()! + sectionInset.bottom)
    }
}


// MARK: - 数据源
protocol WaterFallCollectionViewFlowLayoutDatasource: class {
    // 多少列
    func numberOfColumn(_ waterFallLayout: WaterFallCollectionViewFlowLayout) -> Int
    func waterFallLayout(_ layout: WaterFallCollectionViewFlowLayout, _ indexPath: IndexPath) -> CGFloat
}
