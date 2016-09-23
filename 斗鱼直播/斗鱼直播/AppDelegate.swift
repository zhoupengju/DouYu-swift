//
//  AppDelegate.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/20.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置tabBar的选中颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
    }
}

