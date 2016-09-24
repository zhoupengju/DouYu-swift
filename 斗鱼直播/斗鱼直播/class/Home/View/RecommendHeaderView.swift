//
//  RecommendHeaderView.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class RecommendHeaderView: UICollectionReusableView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    var group : AnchorGroup? {
    
        didSet {
        
            labelTitle.text = group?.tag_name
            
            imageViewIcon.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
}
