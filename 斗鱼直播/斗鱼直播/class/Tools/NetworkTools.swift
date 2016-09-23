//
//  NetworkTools.swift
//  斗鱼直播
//
//  Created by 周鹏钜 on 16/9/23.
//  Copyright © 2016年 周鹏钜. All rights reserved.
//

import UIKit
import AFNetworking

enum PJRequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    
    // let 是线程安全的
    // 多线程访问我们这个变量, 也会保证常量初始化一次
    // swift里面单利就这么一句话
    
    static let shareInstance : NetworkTools = {
        
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
}

// MARK: - 封装请求方法
extension NetworkTools {
    
    func request(methodType : PJRequestType, urlString : String, parameters : [String : AnyObject], finished : (result : AnyObject?, error : NSError?) -> ()) {
        
        //1. 定义成功的闭包
        let successCallBack = { (task:NSURLSessionDataTask, result : AnyObject?) -> Void in
            
            finished(result: result, error: nil)
        }
        
        //2. 定义失败的闭包
        let failCallBack = { (task : NSURLSessionDataTask?, error : NSError) -> Void in
            
            finished(result: nil, error: error)
        }
        
        //3. 发送网络请求
        if methodType == .GET {
            
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failCallBack)
        } else {
            
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failCallBack)
        }
    }
}

// MARK: - 请求accessToken
extension NetworkTools {
    
//    func loadAccessToken(code : String, finshed : (result:[String : AnyObject]?, error : NSError?) -> ()) {
//        
//        // 1. 获取请求的URLString
//        let urlString = "https://api.weibo.com/oauth2/access_token"
//        
//        // 2. 获取请求的参数
//        let parameters = ["client_id" : PJAppKey, "client_secret" : PJAppSecret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : PJRedirectURL]
//        
//        // 3. 发送网络请求
//        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
//            
//            finshed(result: result as? [String : AnyObject], error: error)
//        }
//    }
}

// MARK: - 请求用户信息
extension NetworkTools {
    
    func loadUserInfo(access_token : String, uid : String, finshed : (result : [String : AnyObject]?, error : NSError?) -> ()) {
        
        // 1. 获取请求的url
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2. 获取请求的参数
        let patameters = ["access_token" : access_token, "uid" : uid]
        
        // 3. 发送网络请求
        request(.GET, urlString: urlString, parameters: patameters) { (result, error) -> () in
            
            finshed(result: result as? [String : AnyObject], error: error)
        }
    }
}

// MARK: - 请求首页数据
extension NetworkTools {
    
//    func loadStatuses(since_id : Int, max_id : Int, finshed : (result : [[String : AnyObject]]?, error : NSError?) -> ()) {
//        
//        //1. 获取urlString
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        
//        //2. 获取请求的参数
//        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
//        
//        //3. 请求数据
//        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
//            
//            guard let resultDict = result as? [String : AnyObject] else {
//                
//                finshed(result: nil, error: error)
//                return
//            }
//            
//            finshed(result: resultDict["statuses"] as? [[String : AnyObject]], error: error)
//        }
//    }
}