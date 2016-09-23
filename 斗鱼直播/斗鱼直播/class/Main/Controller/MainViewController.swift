//
//  MainViewController.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/21.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
    }
    
    /// 创建子控制器
    private func addChildVc(storyName : String) {
    
        // 1. 通过storyboary获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2. 将addChildVc作为主控制器
        addChildViewController(childVc)
    }
}
