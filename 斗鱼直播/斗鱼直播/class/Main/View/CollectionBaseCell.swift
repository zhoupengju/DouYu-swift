//
//  CollectionBaseCell.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    /// 控件属性
    @IBOutlet weak var imageViewPlaceHoder: UIImageView!
    @IBOutlet weak var buttonOnline: UIButton!
    @IBOutlet weak var labelNickname: UILabel!
    
    /// 定义模型属性
    var anchor : AnchorModel? {
        
        didSet {
            
            guard let anchor = anchor else { return }
            
            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(anchor.online / 10000)万在线"
            } else {
                onlineStr = "\(anchor.online)在线"
            }
            buttonOnline.setTitle(onlineStr, forState: .Normal)
            
            labelNickname.text = anchor.nickname
            
            guard let iconUrl = NSURL(string: anchor.vertical_src) else { return }
            imageViewPlaceHoder.setImageWithURL(iconUrl)
        }
    }
}
