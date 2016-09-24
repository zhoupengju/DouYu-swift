//
//  CycleModel.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class CycleModel: NSObject {

    // 标题
    var title : String = ""
    
    // 展示的图片地址
    var pic_url : String = ""
    
    // 主播信息对应的房间
    var room : [String : AnyObject]? {
    
        didSet {
        
            guard let room = room else { return }
            
            anchor = AnchorModel(dict: room)
        }
    }
    
    // 主播信息对应的模型对象
    var anchor : AnchorModel?
    
    // MARK: - 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
