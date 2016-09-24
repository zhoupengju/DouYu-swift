//
//  CollectionNormalCell.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {

    /// 控件属性
    @IBOutlet weak var labelRoomname: UILabel!
    
    /// 定义模型属性
    override var anchor : AnchorModel? {
        
        didSet {
            
            // 1. 将属性传递给父类
            super.anchor = anchor
            
            // 2. 房间名称
            labelRoomname.text = anchor?.room_name
        }
    }
}
