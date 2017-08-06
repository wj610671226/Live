//
//  MainTabBarViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/17.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange
        addChildVC("Home")
        addChildVC("Ranking")
        addChildVC("Discover")
        addChildVC("Mine")
    }

    private func addChildVC(_ storyboardName: String) {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName)
        addChildViewController(vc)
    }
}
