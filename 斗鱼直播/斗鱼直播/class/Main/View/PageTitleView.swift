//
//  PageTitleView.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/22.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {

    func pageTitleView(titleView : PageTitleView, selectedIndex index : Int)
}

private let kScrollLineH : CGFloat = 2.0
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    // MARK: - 自定义属性
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    // MARK: - 懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        // 状态栏点击之后想让某一个scrollView回到最顶部, 其他所有的scrollView的这个属性就要设置为false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private lazy var scrollLine : UIView = {
    
        let scrollLine = UIView()
        scrollLine.backgroundColor = kColorMain
        
        return scrollLine
    }()
    
    // MARK: - 自定义构造函数 - 为了直接从外面带参数过来
    init(frame: CGRect, titles : [String]) {
        
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageTitleView {

    private func setupUI() {
    
        // 1. 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加title对应的label
        setupTitleLabels()
        
        // 3. 设置底线和滚动的滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        // 0. 确定label的一些frame值
        let labelW : CGFloat = WIDTH / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
    
        for (index, title) in titles.enumerate() {
        
            // 1. 创建UILabel
            let label = UILabel()
            
            // 2. 设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFontOfSize(16)
            //label.textColor = UIColor.darkGrayColor()
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .Center
            
            // 3. 设置label的frame
            let labelX = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4. 将label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 5. 给label添加手势
            label.userInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: "titleLabelClick:")
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrollLine() {
    
        // 1. 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2. 添加滚动的滑块
        // 2.1 获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        //firstLabel.textColor = kColorMain
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.2 设置 scrollLine 的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

// MARK: - 监听label点击
extension PageTitleView {

    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer) {
        
        // 0. 获取当前的label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1. 如果重复点击的是同一个title, 那就要直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2. 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 3. 切换文字的颜色
        //currentLabel.textColor = kColorMain
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        //oldLabel.textColor = UIColor.darkGrayColor()
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4. 保存最新label的下标值
        currentIndex = currentLabel.tag
        
        // 5. 滚动条位置发生变化
        let scrolLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animateWithDuration(0.2) { () -> Void in
            
            self.scrollLine.frame.origin.x = scrolLineX
        }
        
        // 6. 通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

// MARK: - 对外暴露的方法
extension PageTitleView {
    
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        // 1. 取出 sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3. 处理颜色的渐变 (复杂)
        // 3.1 取出变化的范围
        let colorDelta = (kSelectColor.0-kNormalColor.0, kSelectColor.1-kNormalColor.1, kSelectColor.2-kNormalColor.2)
        
        // 3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4. 记录最新的index - 必须要记录
        currentIndex = targetIndex
    }
}
