//



//  RecommendGameCell.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class RecommendGameCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    // MARK: - 定义模型属性
    var group : AnchorGroup? {
    
        didSet {
        
            labelName.text = group?.tag_name
            
            let iconUrl = NSURL(string: group?.icon_url ?? "")!
            imageIcon.setImageWithURL(iconUrl, placeholderImage: UIImage(named: "home_more_btn"))
        }
    }
    
    // MARK: - 系统回调
}
