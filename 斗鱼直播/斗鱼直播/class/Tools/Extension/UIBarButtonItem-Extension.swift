//
//  UIBarButtonItem-Extension.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/21.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

// MARK: - 对系统类进行扩展, 也就是分类
// 1. 类方法
// 2. 构造函数
extension UIBarButtonItem {

    // 类方法
//    class func createItem(imageName : String, highImageName : String, size : CGSize) -> UIBarButtonItem {
//    
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), forState: .Normal)
//        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
//        btn.frame = CGRect(origin: CGPointZero, size: size)
//        
//        return UIBarButtonItem(customView: btn)
//    }
    
    // 便利构造函数
    // 1. 以convenience开头
    // 2. 在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init(imageName : String, highImageName : String, size : CGSize) {
    
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        btn.frame = CGRect(origin: CGPointZero, size: size)
        
        self.init(customView : btn)
    }
}
