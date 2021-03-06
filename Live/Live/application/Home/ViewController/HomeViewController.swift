//
//  HomeViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/18.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    fileprivate lazy var typeModels: [HomeTypeModel] = Array() // 存储model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    
        initUI()
    }
    
    
    // MARK: - 设置导航栏
    private func setNavigationBar() {
        
        title = "首页"
 
        let rightItem = UIBarButtonItem(title: "直播推流", style: .plain, target: self, action: #selector(HomeViewController.clickItem))
        navigationItem.rightBarButtonItem = rightItem
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 35))
        searchBar.placeholder = "主播昵称/房间号"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = UIColor.white
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
//        navigationItem.titleView = searchBar
        
        
//        let s = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 35))
//        s.backgroundColor = UIColor.red
//        navigationItem.titleView = s
    }

    
    private func initUI() {
        
        loadTypeData()
        
        let titles = typeModels.map { $0.title }
        var viewControllers: [UIViewController] = Array()
        let titleStyle = PageTitleViewStyle()
        for item in typeModels {
            let vc = WaterfallViewController()
            vc.type = item.type
            viewControllers.append(vc)
        }
        
        let y:CGFloat = IS_IPHONE_X ? 88 : 64
        let height = KScreenHeight - 49 - y
        let frame = CGRect(x: 0, y: y, width: KScreenWidth, height: height)
        let pageView = PageView(frame: frame, titles: titles, titleStyle: titleStyle, childVC: viewControllers, parentVC: self)
        view.addSubview(pageView)
    }
    
    
    @objc func clickItem(sender: UIBarButtonItem) {
        let vc = MyLiveViewController()
        self.present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func loadTypeData() {
        // 读取配置文件
        let path = Bundle.main.path(forResource: "types", ofType: "plist")
        let typeArray = NSArray(contentsOfFile: path!) as! [[String : Any]]
        for item in typeArray {
            let model = HomeTypeModel(item)
            typeModels.append(model)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
