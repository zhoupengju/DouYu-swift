
//
//  RecommendViewModel.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

/**
<#Description#>

- parameter finishCallBack: <#finishCallBack description#>
*/

import UIKit

class RecommendViewModel {

    // MARK: - 懒加载属性
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    private lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    private lazy var prettyGroup : AnchorGroup = AnchorGroup()
}

extension RecommendViewModel {
   
    func requestData(finishCallBack : () -> ()) {
        
        let dGroup = dispatch_group_create()
        
        // 0.定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
    
        // 1. 请求推荐数据 第一部分
        dispatch_group_enter(dGroup)
        NetworkTools.shareInstance.request(.GET, urlString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentTime()]) { (result, error) -> () in
            
            // 1. 将 result 转成 字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2. 使用data这个key值, 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3. json数据转模型
            // 3.1 创建组
//            let group = AnchorGroup()
            
            // 3.2 设置属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            // 3.3 获取主播数据
            for dict in dataArray {
                
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            dispatch_group_leave(dGroup)
        }
        
        // 2. 请求颜值数据 第二部分
        
        dispatch_group_enter(dGroup)
        NetworkTools.shareInstance.request(.GET, urlString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result, error) -> () in
            
            // 1. 将 result 转成 字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2. 使用data这个key值, 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3. json数据转模型
            // 3.1 创建组
//            let group = AnchorGroup()
            
            // 3.2 设置属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            // 3.3 获取主播数据
            for dict in dataArray {
            
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            
            dispatch_group_leave(dGroup)
        }
        
        // 3. 请求后面部分的游戏数据   2-12部分数据
        // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&offset=1474622388
        dispatch_group_enter(dGroup)
        NetworkTools.shareInstance.request(.GET, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result, error) -> () in
            
            // 1. 将 result 转成 字典
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2. 使用data这个key值, 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3. 遍历数组, 获取字典, 并且将字典转成模型对象
            for dict in dataArray {
            
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            
            dispatch_group_leave(dGroup)
        }
        
        dispatch_group_notify(dGroup, dispatch_get_main_queue()) { () -> Void in
            
            self.anchorGroups.insert(self.prettyGroup, atIndex: 0)
            self.anchorGroups.insert(self.bigDataGroup, atIndex: 0)
            
            finishCallBack()
        }
    }
}
