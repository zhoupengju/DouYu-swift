//
//  AnchorGroup.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

// Anchor:主播
class AnchorGroup: NSObject {

    /// 改组中对应的房间信息
    var room_list : [[String : AnyObject]]? {
    
        didSet {
        
            guard let room_list = room_list else {
                return
            }
            
            for dict in room_list {
                
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    
    /// 改组显示的标题
    var tag_name : String = ""
    
    /// 改组显示的图标
    var icon_name : String = "home_header_normal"
    
    /// 主播的模型对象数组
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    override init() {
        
    }
    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    override func setValue(value: AnyObject?, forKey key: String) {
//        
//        if key == "room_list" {
//            if let arrayRoom = value as? [[String : AnyObject]] {
//            
//                for dict in arrayRoom {
//                
//                    Anchors.append(AnchorModel(dict: dict))
//                }
//            }
//        }
//    }
}
