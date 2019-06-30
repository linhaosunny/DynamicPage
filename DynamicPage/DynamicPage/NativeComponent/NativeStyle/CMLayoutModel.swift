//
//  CMLayoutStyle.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit
import HandyJSON

enum CMLayoutStyle : String, HandyJSONEnum {
    // 流式布局
    case FlowLayout = "FlowLayout"
    // 线性布局
    case LinerLayout = "LinerLayout"
    // 瀑布流布局
    case WaterfallLayout = "WaterfallLayout"
    // 橱窗布局效果（一个大的两个小的）
    case ShopWindowLayout = "ShopWindowLayout"
}

enum CMLayoutDirection : Int, HandyJSONEnum {
    // 水平方向
    case vertical = 0
    // 垂直方向
    case horizontal = 1
    
}
class CMLayoutModel : CMBaseModel {
    var layout:CMLayoutStyle?
    // 内边框边距
    var padding:[Float]?
    // 外边框边距
    var margin:[Float]?
    // 列比例 数组中所有值加起来小于等于1.0，如果没有设置默认就是平均值
    var columnRatios:[Float]?
    // 固定长宽高度比例布局
    var lineRatio:Float = 0.0
    // 固定高度布局
    var lineHeight:Float = 0.0
    // 固定列长度 (线性布局，水平布局有效)
    var columnWidth:Float = 0.0
    // 列宽度与屏幕宽度的对比
    var columnScreenWidthRatio:Float = 0.0
    // 列间距
    var columnMargin:Float = 0.0
    // 行间距
    var lineMargin:Float = 0.0
    // 布局方向
    var layoutDirection:CMLayoutDirection = .vertical
    // 列数
    var column:Int = 1
    // 元素
    var elements:[CMElementModel]?
    // 背景色
    var color:String?
}
