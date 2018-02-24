//
//  GiftView.swift
//  Live
//
//  Created by wangjie on 2017/7/2.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

private let KGiftViewCellID: String = "KGiftViewCellID"

class GiftView: UIView, LoadNibProtocol {
    
    var sendGiftHandler: ((_ giftmodel: GiftModel) -> Void)?
    
    fileprivate var selectedIndexPath: IndexPath?
    @IBOutlet weak var balanceLabel: UILabel! // 余额
    @IBOutlet weak var giftView: UIView!
    
    fileprivate lazy var viewModel: GiftViewModel = GiftViewModel()
    fileprivate var collectionView: PageCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 获取数据
        viewModel.loadGifterData({
            self.collectionView.reloadData()
        }) { (error) in
            
        }
        
        initUI()
        
    }
    
    private func initUI() {
        let titles: [String] = ["热门", "高级", "豪华", "专属", "其他"]
        let style = PageTitleViewStyle()
        style.isScale = false
        style.isScroll = false
        style.backgroundColor = UIColor(r: 0, g: 0, b: 0)
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        let layout = PageCollectionViewlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = PageCollectionView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: giftView.bounds.height), titles: titles, titleStyle: style, layout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nib: UINib(nibName: "GiftViewCell", bundle: nil), forCellWithReuseIdentifier: KGiftViewCellID)
        giftView.addSubview(collectionView)
        
    }
    
    @IBAction func clickSendGift(_ sender: UIButton) {
        guard let indexPath = selectedIndexPath else {
            let alert = UIAlertView(title: "温馨提示", message: "请选择要赠送的礼物", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let model = viewModel.giftData[indexPath.section][indexPath.item]
        sendGiftHandler?(model)
    }
}


extension GiftView: PageCollectionViewDelegate, PageCollectionViewDataSource {
    func pageCollectionView(_ pageCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
    
    func numberOfSections(in pageCollectionView: UICollectionView) -> Int {
        return viewModel.giftData.count
    }
    
    func pageCollectionView(_ pageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.giftData[section].count
    }
    
    func pageCollectionView(_ pageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: KGiftViewCellID, for: indexPath) as! GiftViewCell
        
        cell.model = viewModel.giftData[indexPath.section][indexPath.item]
        
        return cell
    }
}

