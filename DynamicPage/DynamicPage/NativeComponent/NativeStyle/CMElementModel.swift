//
//  CMElementModel.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit
import HandyJSON

enum CMElementStyle : String , HandyJSONEnum {
    case banner = "banner"
    
    case goods = "goods"
    
    case search = "search"
    
    case image = "image"
    
    case text = "text"
}

class CMElementModel: CMBaseModel {
    var type:CMElementStyle = .image

    // 内边距
    var padding:[Float]?
    
    // 外边距
    var margin:[Float]?
    
    // 高度
    var height:Float = 0.0
    
    // 宽度
    var width:Float = 0.0
    
    // 图片链接
    var imageUrl:String?
    
    // 宽高比例
    var ratio:Float = 0.0

    // 字符
    var text:String?
    
    // 跳转Url
    var actionUrl:String?
    
    // 子元素
    var elements:[CMElementModel]?
    
    // 轮播图样式设置
    var bannerStyle:CMBannerStyle?
    
    // 字体样式
    var textStyle:CMTextStyle?
    
    // 跳转地址
    var jumpUrl:String?
}
