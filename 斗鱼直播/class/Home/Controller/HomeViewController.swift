

//
//  HomeViewController.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/21.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

/**
    游戏直播:   斗鱼, 虎牙, 龙珠, 熊猫
    秀场直播:   映客,YY手机, 新浪秀场, 花椒, 千帆
*/

/**
    播放
        不管是手机还是电脑, 都会把采集到的视频传输到服务器端
        iOS 就是把它播放出来

    录播
        主播通过手机直播, 客户端需要将直播的视频传输给服务器, 以便其他的客户端播放
*/

/**
    即时通信
        观众和主播互动的礼物, 聊天即使呈现
        弹幕
*/

/**
    整体界面的搭建和展示
*/

/**
    技术分析
        数据: 都是在服务器中, 客户端要实时请求数据(http, tcp, rtmp, rtsp)
        解协议: 拿到封装格式的数据
        封装格式数据:
        解封装: 视频里面是把视频和音频文件经过一种封装格式放到一起的. 分离出视频和音频
        视频压缩数据: ->音频解码 ->音频原始数据
        音频压缩数据: ->视频解码 ->视频原始数据
        音视频同步: 同步之后, 画面和声音才能同步.
        分别传输给音频和视频驱动
*/

/**
    项目选择:
        秀场直播: 比较简单
        游戏直播: 比较复杂, 里面包含了秀场直播
        斗鱼比较复杂, 因此选择斗鱼直播进行模仿
*/

/**
    SVN: 集中式
    GIT: 分布式
*/

/**
    视频iOS8, 9 不同, 进行适配
        1. 用storyboard创建控制器, 然后使用代码添加
        2. 直接使用storyrefactor创建 - 只适用于iOS9

*/

/**
    首页框架分析
    1. 封装 pageTitleView
        1.1 自定义view, 并且自定义构造函数
        1.2 添加子控件 uiscrollview
    2. 封装 pageContentView
    3. 处理 pageTitleView 和 pageContentView 之间的逻辑
*/

/**
    cocopod 的使用
    1. pod init
    2. 用 xcode 打开Podfile
    3. swift要打开 use_frameworks!,  swift 是动态库
    4. pod install --no-repo-update
*/

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK: - 懒加载属性
    // 通过闭包的形式创建PageTitleView
    private lazy var pageTitleView : PageTitleView = {[weak self] in
    
        let titleFrame = CGRectMake(0, kStatusBarH + kNavgationBarH, WIDTH, kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
//        titleView.backgroundColor = UIColor.purpleColor()
        
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = { [weak self] in
    
        // 1. 确定内容的frame
        let H = kStatusBarH+kNavgationBarH+kTitleViewH
        let contentFrame = CGRect(x: 0, y: H, width: WIDTH, height: HEIGHT-H-kTabBarH)
        
        // 2. 确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
        
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVc: childVcs, parentViewController: self)
        contentView.delegate = self
        
        return contentView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 设置UI界面
        setupUI()
    }
}

// MARK: - 设置UI
extension HomeViewController {

    private func setupUI() {
    
        // 0. 不需要调整UISrollow的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 设置导航栏
        setupNavigationBar()
        
        // 2. 添加titleView
        view.addSubview(pageTitleView)
        
        // 3. 添加PageContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.orangeColor()
    }
    
    private func setupNavigationBar() {
    
        // 1. 左侧导航栏
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), forState: .Normal)
        btn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        // 2. 设置右侧导航栏
        // 2.1 类方法
//        let size = CGSize(width: 30, height: 30)
//        let historyItem = UIBarButtonItem.createItem("image_my_history", highImageName: "image_my_history_clicked", size: size)
//        
//        let searchItem = UIBarButtonItem.createItem("image_my_history", highImageName: "image_my_history_clicked", size: size)
//        
//        let qrcodeItem = UIBarButtonItem.createItem("Image_scan", highImageName: "Image_scan_click", size: size)
        
        // 2.2 构造方法
        let size = CGSize(width: 30, height: 30)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "image_my_history_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_click", size: size)
        
        navigationItem.rightBarButtonItems = [searchItem, qrcodeItem, historyItem]
    }
}

// MARK: - PageTitleViewDelegate代理方法
extension HomeViewController : PageTitleViewDelegate {

    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        
        pageContentView.setCurrentIndex(index)
    }
}

// MARK: - PageContentViewDelegate代理方法
extension HomeViewController : PageContentViewDelegate {

    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
