
//
//  pageContentView.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/22.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {

    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let contentCellId = "contentCellId"

class PageContentView: UIView {
    
    // MARK: - 定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?   // weak只能修饰可选类型
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    // MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        
        // 1. 创建layout
        let layout = UICollectionViewFlowLayout()
        // ? 后面的都是可选链, 但是layout.itemSize接收到的是确定的类型, 因此报错
        // self肯定是存在的, 故而可以强制解包
        layout.itemSize = (self?.bounds.size)!
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // 2. 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        
        return collectionView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, childVc : [UIViewController], parentViewController : UIViewController?) {
        
        self.childVcs = childVc
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        // 1. 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView {

    private func setupUI() {
    
        // 1. 将所有的子控制器添加到父控制器中
        for childVc in childVcs {
        
            parentViewController?.addChildViewController(childVc)
        }
        
        // 2. 添加UICollectionView, 用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK: - UICollectionViewDataSource 数据源方法
extension PageContentView : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(contentCellId, forIndexPath: indexPath)
        
        // 2. 给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate 代理方法
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // 0. 判断是否为点击时间
        if isForbidScrollDelegate { return }
        
        // 1. 定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2. 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {  // 左滑
        
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2. 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3. 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4. 如果完全划过去了
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {    // 右滑
        
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2. 计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3. 计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
            
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3. 将 progress,sourceIndex,targetIndex 传递给 titleView
//        print(progress, sourceIndex, targetIndex)
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK: - 对外暴露的方法
extension PageContentView {

    func setCurrentIndex(currentIndex : Int) {
        
        // 1. 记录是否要禁止滚动
        isForbidScrollDelegate = true
    
        // 2. 滚动到正确位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
