//
//  RecommendViewController.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//  首页 - 推荐

/**
    苹果的MVC是这么定义的 : 所有的对象都可以被归类为一个model, 一个view, 一个controller
    那么网络的代码应该是放在哪里? 不知道的时候我们就放在控制器中, MVC就是这么做的
    这样就导致了许多的代码难以管理, 控制器变的相当脓肿

    MVVM 设计模式来自于微软
    他和MVC很像, 只是引入了新的组件ViewModel(有部分代码不知道放到哪里, 放到它里面就行了)
    ViewModel : 用户的输入验证逻辑, 视图显示逻辑, 网络请求, 不知道放到哪里的代码. 就可以放到这里
    这些逻辑放到ViewModel中之后, 视图控制器本身就不会脓肿了

*/

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (WIDTH - kItemMargin * 3) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3

private let kHeaderViewH : CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class RecommendViewController: UIViewController {

    // MARK: - 懒加载属性
    private lazy var recommendVM :RecommendViewModel = RecommendViewModel()
    private lazy var colltionView : UICollectionView = { [unowned self] in
    
        // 创建布局
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        layout.headerReferenceSize = CGSize(width: WIDTH, height: kHeaderViewH)
        
        // 这个地方设置frame非常重要 self.view.bounds 是整个屏幕的尺寸
        // 但是self.view的尺寸是这个小, 按道理说他会随着self.view的尺寸变小而一起变小
        // 这个时候我们就得手动的处理他了 设置跟随就ok了
        // colltionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        let colltionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        colltionView.backgroundColor = UIColor.whiteColor()
        colltionView.delegate = self
        colltionView.dataSource = self
        colltionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        colltionView.registerNib(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        colltionView.registerNib(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        colltionView.registerNib(UINib(nibName: "RecommendHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return colltionView
    }()
    
    // MARK: - 系统属性
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 设置UI界面
        setupUI()
        
        // 2. 发送网络请求
        loadData()
    }
}

// MARK: - 请求数据
extension RecommendViewController {

    private func loadData() {
        
        recommendVM.requestData()
    }
}

// MARK: - 设置UI界面
extension RecommendViewController {

    private func setupUI() {
    
        // 1. 将colltionView添加到控制器的view中
        view.addSubview(colltionView)
    }
}

// MARK: - UICollectionViewDataSource 数据源方法
extension RecommendViewController : UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 8
        }
        
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        
        if indexPath.section == 1 {
            cell = colltionView.dequeueReusableCellWithReuseIdentifier(kPrettyCellID, forIndexPath: indexPath)
        } else {
            cell = colltionView.dequeueReusableCellWithReuseIdentifier(kNormalCellID, forIndexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // 1. 取出setion的HeaderView
        let headerView = colltionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kHeaderViewID, forIndexPath: indexPath)
        
        return headerView
    }
}

extension RecommendViewController :  UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        if (indexPath.section == 1) {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}
