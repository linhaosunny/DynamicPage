//
//  CMUIConfig.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
    
    static func iphoneXUp() -> Bool {
        if isSimulator {
            return true
        } else {
            return UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize((UIScreen.main.currentMode?.size)!, CGSize(width: 1125, height: 2436)) || __CGSizeEqualToSize((UIScreen.main.currentMode?.size)!, CGSize(width: 828, height: 1792)) ||
                __CGSizeEqualToSize((UIScreen.main.currentMode?.size)!, CGSize(width: 1242, height: 2688)): false
        }
    }
}

let iphoneXAll = Platform.iphoneXUp()

/// 状态栏高度
let kStatusBarHeight: CGFloat = iphoneXAll ? 44.0 : 20.0
/// 导航栏高度
let kNavigationBarHeight: CGFloat = 44.0

/// 顶部安全区距离
let kTopSafeOffset = UIApplication.shared.statusBarFrame.size.height > 20 ? (kStatusBarHeight - 20) :0
/// 底部安全区距离
let kBottomSafeOffset = iphoneXAll ? 34.0 : 0

/// 导航栏加状态栏的高度
let kNavAndStatusBarHeight: CGFloat = CGFloat(kStatusBarHeight) + kNavigationBarHeight
/// tabBar加底部安全区域的高度
let kTabbarAndSafeOffsetHeight: CGFloat = CGFloat(kBottomSafeOffset + 49.0)

var ScreenWidth:CGFloat {
    get {
        return UIScreen.main.bounds.width
    }
}

var ScreenHeight:CGFloat {
    get {
        return UIScreen.main.bounds.height
    }
}


/// 占位图颜色，淡灰色(庚斯博罗灰)
let spaceColor = UIColor(hexString: "#DCDCDC")

let themeTintColor = UIColor(hexString: "#ED0535")
