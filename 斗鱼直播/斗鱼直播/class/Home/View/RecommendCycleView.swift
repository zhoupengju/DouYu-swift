//
//  RecommendCycleView.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/24.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

private let kCycleViewID = "kCycleViewID"

class RecommendCycleView: UIView {
    
    // MARK: - 定义属性
    var cycleTimer : NSTimer?
    var cycleModels : [CycleModel]? {
    
        didSet {
        
            collectionView.reloadData()
            
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            // 默认滚动到中间的位置, 是为了方便用户可以向左边滚动
            let indexPath = NSIndexPath(forItem: (cycleModels?.count ?? 0) * 10, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
            
            removeCycleTimer()
            addCycleTimer()
        }
    }

    // MARK: - 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置改控件不随着父控件的拉伸而拉伸
        autoresizingMask = .None
        
        // 注册cell
        collectionView.registerNib(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleViewID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension RecommendCycleView {

    class func recommendCycleView() -> RecommendCycleView {
    
        return NSBundle.mainBundle().loadNibNamed("RecommendCycleView", owner: nil, options: nil).first as! RecommendCycleView
    }
}

extension RecommendCycleView : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000    // 这里没有性能的问题, 系统优化了
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCycleViewID, forIndexPath: indexPath) as! CollectionCycleCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.redColor() : UIColor.orangeColor()
        
        let cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        
        cell.cycleModel = cycleModel
        
        return cell
    }
}

extension RecommendCycleView : UICollectionViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

// MARK: - 对定时器的操作方法
extension RecommendCycleView {

    private func addCycleTimer() {
    
        cycleTimer = NSTimer(timeInterval: 3.0, target: self, selector: "scrollToNext", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(cycleTimer!, forMode: NSRunLoopCommonModes)
    }
    
    private func removeCycleTimer() {
        
        cycleTimer?.invalidate()    // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc private func scrollToNext() {
    
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        
    }
}
