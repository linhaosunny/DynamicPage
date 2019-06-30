//
//  CMCardLayoutModel.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/14.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMCardLayoutModel {
    // 布局行高
    var lineHeights:[Float] = []
    // 布局样式
    var layout:CMLayoutStyle = .LinerLayout
    // 布局外部边框
    var margin:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    // 布局内部边框
    var padding:UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    // 布局序号
    var section:Int = 0
}
