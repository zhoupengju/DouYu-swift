//
//  AnchorModel.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {

    /// 房间号
    var room_id : Int = 0
    
    /// 房间图片对应的url
    var vertical_src : String = ""
    
    /// 判断是手机直播还是电脑直播   0: 电脑直播     1: 手机直播
    var isVertical : Int = 0
    
    /// 房间名称
    var room_name : String = ""
    
    /// 主播昵称
    var nickname : String = ""
    
    /// 观看人数
    var online : Int = 0
    
    /// 所在城市
    var anchor_city : String = ""
    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
