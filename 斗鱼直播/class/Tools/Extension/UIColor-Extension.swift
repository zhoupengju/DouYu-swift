//
//  UIColor-Extension.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/22.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
