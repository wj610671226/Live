//
//  BaseNavigationViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/19.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.init(kCTForegroundColorAttributeName as String) : UIColor.white]
        
        // 获取 UIGestureRecognizer 成员属性
//        var count: UInt32 = 0
//        guard let ivar = class_copyIvarList(UIGestureRecognizer.self, &count) else { return }
//        for index in 0..<count {
//            let nameIvar = ivar_getName(ivar[Int(index)])
//            let name = String(cString: nameIvar!)
//            print(name)  // _targets
//        }
        
        // 找到系统 interactivePopGestureRecognizer 手势的 _targets 的值
        guard let value = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [NSObject] else { return }
//        print(value)
        let target = value.first?.value(forKey: "target")
        // 获取action 失败  直接拿到系统的方法名
//        let action = value.first?.value(forKey: "action")
//        print(action)
        let pan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        view.addGestureRecognizer(pan)
        
    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
