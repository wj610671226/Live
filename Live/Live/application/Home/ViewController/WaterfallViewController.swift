//
//  WaterfallViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/22.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

fileprivate let cellID: String = "WaterFallCellID"

class WaterfallViewController: UIViewController {

    var type: Int = 0 // 请求类型
    fileprivate var index: Int = 0 // 请求页面
    fileprivate lazy var viewModel: WaterFallViewModel = WaterFallViewModel()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WaterFallCollectionViewFlowLayout()
        layout.delegate = self
        let padding: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame:
            CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - 44 - 64 - 49), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "WaterFallCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        getDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}


// MARK: - UICollectionViewDataSource
extension WaterfallViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WaterFallCollectionViewCell
        
        cell.model = viewModel.data[indexPath.item]
        
        if indexPath.item == viewModel.data.count - 1 {
            index += 1
            getDataFromServer()
        }
        
        return cell
    }
    
}


// MARK: - UICollectionViewDataSource
extension WaterfallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let liveVC = LiveViewController()
        liveVC.model = viewModel.data[indexPath.item]
        navigationController?.pushViewController(liveVC, animated: true)
    }
}


// MARK: - WaterFallCollectionViewFlowLayoutDatasource
extension WaterfallViewController: WaterFallCollectionViewFlowLayoutDatasource {
    func numberOfColumn(_ waterFall: WaterFallCollectionViewFlowLayout) -> Int {
        return 2
    }
    
    func waterFallLayout(_ layout: WaterFallCollectionViewFlowLayout, _ indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? KScreenWidth * 2 / 3 : KScreenWidth * 0.5
    }
}


// MARK: - 获取数据
extension WaterfallViewController {
    fileprivate func getDataFromServer() {
        HUD.show(.progress)
        viewModel.loadWaterFallData(type, index, {
            HUD.hide()
            self.collectionView.reloadData()
        }) { (error) in
            HUD.hide()
        }
    }
}
