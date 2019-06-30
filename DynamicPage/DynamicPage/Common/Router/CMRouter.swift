//
//  CMRounter.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/21.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

enum CMRouterUrlType {
    // 非法地址
    case illegal
    // app 路由
    case appUrl
    // h5 路由
    case h5Url
}

enum CMRouterAppUrlType {
    // 非法地址
    case illegal
    // 商品详情
    case goodsDetail
    // 购物车
    case shopCart
    // 订单页面
    case order
}

enum CMRouterTabbarUrl : Int{
    // 首页
    case home = 0
    // 购物车
    case shopCart = 1
    // 订单列表
    case order = 2
    
}


class CMRouter {
    static let shared = CMRouter()
    
    fileprivate var tabUrl:CMRouterTabbarUrl = .home
    
    fileprivate var subRouter:String?
    
    fileprivate var oldTabUrl:CMRouterTabbarUrl = .home
    
    fileprivate var oldSubRouter:String?
    
    fileprivate var isSetOldUrl:Bool = false
    
    /// 设置路由
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - subRouter: <#subRouter description#>
    class func setTabUrl(url:CMRouterTabbarUrl,subRouter:String?) {
        shared.tabUrl = url
        shared.subRouter = subRouter
        
    }
    
    /// 设置当前路由和旧的路由
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - subRouter: <#subRouter description#>
    ///   - oldUrl: <#oldUrl description#>
    ///   - oldSubRouter: <#oldSubRouter description#>
    class func setTabUrlWithOld(url:CMRouterTabbarUrl,subRouter:String?,oldUrl:CMRouterTabbarUrl,oldSubRouter:String?) {
        shared.tabUrl = url
        shared.subRouter = subRouter
        shared.oldTabUrl = oldUrl
        shared.oldSubRouter = oldSubRouter
        shared.isSetOldUrl = true
    }
    
    /// 恢复使用旧的路由
    class func recoverOldUrl() {
        if isSetOldUrl() {
            shared.tabUrl = shared.oldTabUrl
            shared.subRouter = shared.oldSubRouter
        }
    }
    
    /// 清除旧的路由
    class func clearOldUrl() {
        if isSetOldUrl() {
            shared.isSetOldUrl = false
            shared.oldTabUrl = .home
            shared.oldSubRouter = nil
        }
    }
    
    /// 获取根路由
    ///
    /// - Returns: <#return value description#>
    class func getTabUrl() -> CMRouterTabbarUrl {
        return shared.tabUrl
    }
    
    /// 获取子路由
    ///
    /// - Returns: <#return value description#>
    class func getSubRouter() -> String? {
        return shared.subRouter
    }
    
    /// 是否设置了旧的登录
    ///
    /// - Returns: <#return value description#>
    class func isSetOldUrl() -> Bool {
        return shared.isSetOldUrl
    }
    
    /// 加入日期
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - paramStr: <#paramStr description#>
    /// - Returns: <#return value description#>
    class func getDataFromParamStr(key:String,paramStr:String) ->String? {
        let datas = paramStr.components(separatedBy: "=")
        
        if datas.count > 0,let datasKey = datas.first,datasKey == key {
            return datas.last
        }
        
        return nil
    }
    
    /// 从路由中获取参数
    ///
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - jumpUrl: <#jumpUrl description#>
    /// - Returns: <#return value description#>
    class func getParamsFromJumpUrlfor(key:String,jumpUrl:String?) ->String? {
        guard let urlStr = jumpUrl, !urlStr.isEmpty else {
            return nil
        }
        
        let urlComponets = urlStr.components(separatedBy: "?")
        
        if urlComponets.count > 0,let paramsStr = urlComponets.last {
            let params = paramsStr.components(separatedBy: "&")
            
            // 如果能分
            if params.count > 0 {
                
                for item in 0..<params.count {
                    let str = params[item]
                    if let data = getDataFromParamStr(key: key, paramStr: str) {
                        return data
                    }
                }
                
            } else {
                return getDataFromParamStr(key: key, paramStr: paramsStr)
            }
        }
        
        return nil
    }
    
    /// 判断地址类型
    ///
    /// - Parameter url: <#url description#>
    /// - Returns: <#return value description#>
    class func isUrlType( url:String?) -> CMRouterUrlType {
        guard let urlStr = url, !urlStr.isEmpty else {
            return .illegal
        }
        
        if urlStr.contains("https://") || urlStr.contains("http://") {
            return .h5Url
        }
        
        if urlStr.contains("app-mall://") {
            return .appUrl
        }
       
        return .illegal
    }
    
    /// app路径判断
    ///
    /// - Parameter url: <#url description#>
    /// - Returns: <#return value description#>
    class func isAppUrlType( url:String) -> CMRouterAppUrlType {
        if url.contains("app-mall://goods_detail") {
            return .goodsDetail
        }
        
        if url.contains("app-mall://shopCart") {
            return .shopCart
        }
        
        if url.contains("app-mall://order") {
            return .order
        }
        
        return .illegal
    }
    
    /// 从当前控制器切换到tabbar控制器
    ///
    /// - Parameters:
    ///   - controll: <#controll description#>
    ///   - tabbarUrl: <#tabbarUrl description#>
    class func changeTabarRouter(controll:UIViewController, tabbarUrl:CMRouterTabbarUrl,ignoreUrl:Bool) {
        
        if !ignoreUrl {
            setTabUrl(url: tabbarUrl, subRouter: nil)
        }
    
        controll.navigationController?.tabBarController?.selectedIndex = tabbarUrl.rawValue
        if  let count = controll.navigationController?.viewControllers.count,count > 1 {
            controll.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}
