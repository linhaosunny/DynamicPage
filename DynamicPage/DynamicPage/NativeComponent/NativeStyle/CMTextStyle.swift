//
//  CMTextStyle.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/17.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit
import HandyJSON

enum CMTextType : String , HandyJSONEnum {
    case title = "title"
    
    case subTitle = "subTitle"
    
    case price = "price"
    
    case deletePrice = "deletePrice"
}


class CMTextStyle: CMBaseModel {
    // 字符类型
    var type:CMTextType = .title
    // 字体颜色
    var color:String?
    // 字体大小
    var fontSize:Float = 0.0
    // 字体名称
    var fontName:String?
    
}
