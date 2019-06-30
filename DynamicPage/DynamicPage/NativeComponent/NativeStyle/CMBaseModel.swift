//
//  CMBaseModel.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/15.
//  Copyright © 2019 YCM. All rights reserved.
//  基础模型

import UIKit
import HandyJSON

class CMBaseModel: NSObject, HandyJSON {
    
    // HandyJSONEnum 枚举继承这个协议即可解析
    
    var idr = UUID()
    //    var date: Date?
    //    var decimal: NSDecimalNumber?
    //    var url: URL?
    //    var data: Data?
    //    var color: UIColor?
    
    required override init() {}
    
    func mapping(mapper: HelpingMapper) {   //自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
        //        mapper <<<
        //            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
        //
        //        mapper <<<
        //            decimal <-- NSDecimalNumberTransform()
        //
        //        mapper <<<
        //            url <-- URLTransform(shouldEncodeURLString: false)
        //
        //        mapper <<<
        //            data <-- DataTransform()
        //
        //        mapper <<<
        //            color <-- HexColorTransform()
    }
}

//extension CMBaseModel: Equatable, Hashable {
//
//    var hashValue: Int {
//        return idr.hashValue
//    }
//
//    public static func ==(lhs: CMBaseModel, rhs: CMBaseModel) -> Bool {
//        return lhs.idr == rhs.idr
//    }
//}
