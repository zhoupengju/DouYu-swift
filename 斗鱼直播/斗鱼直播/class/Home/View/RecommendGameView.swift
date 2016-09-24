
//
//  RecommendGameView.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"

class RecommendGameView: UIView {
    
    // MARK: - 定义数据的属性
    var groups : [AnchorGroup]? {

        didSet {
        
            groups?.removeFirst()
            groups?.removeFirst()
            
            // 添加更多
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            
            groups?.append(moreGroup)
            
            collectionView.reloadData()
        }
    }
    
    // MARK: - 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoresizingMask = .None
        
        collectionView.registerNib(UINib(nibName: "RecommendGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension RecommendGameView {

    class func recommendGameView() -> RecommendGameView {
    
        return NSBundle.mainBundle().loadNibNamed("RecommendGameView", owner: nil, options: nil).first as! RecommendGameView
    }
}

extension RecommendGameView : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kGameCellID, forIndexPath: indexPath) as! RecommendGameCell

        cell.group = groups![indexPath.row]
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.redColor() : UIColor.greenColor()
        
        return cell
    }
}
