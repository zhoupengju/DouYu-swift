//
//  CollectionCycleCell.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class CollectionCycleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var title: UILabel!

    var cycleModel :CycleModel? {
    
        didSet {
        
            title.text = cycleModel?.title
            
            let iconUrl = NSURL(string: cycleModel?.pic_url ?? "")!
            imageview.setImageWithURL(iconUrl, placeholderImage: UIImage(named: "Img_default"))
        }
    }
}
