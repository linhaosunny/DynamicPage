//
//  CMStringExtension.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//  字符拓展类

import UIKit

extension String {
    static func isEmptyString(content:String?) ->Bool {
        guard let str = content,str != "" else {
            return true
        }
        
        return false
    }
    
    func isNetworkUrl() -> Bool {
        if self.contains("https://") || self.contains("http://") {
            return true
        }
        
        return false
    }
    
    func dictionary() -> [String:Any]? {
        if self == "" {
            return nil
        }
        
        if let data = self.data(using: String.Encoding.utf8) {
            
            if let value = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                return value as? [String:Any]
            }
        }
        return nil
    }
}

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    /// url编码RFC3986
    ///
    /// - Returns: <#return value description#>
    func urlEncodingRFC3986() -> String {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet) ?? ""
    }
    
    /// url编码过滤RFC1738
    ///
    /// - Parameter unreserved: <#unreserved description#>
    /// - Returns: <#return value description#>
    func urlEncodingRFC1738() -> String {
        let base_unreserved = "-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: base_unreserved)
        
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet) ?? ""
    }
    
    
    func utf8encodedString() ->String {
        var arr = [UInt8]()
        arr += self.utf8
        return String(bytes: arr,encoding: String.Encoding.utf8) ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    /**
     *   编码Data
     */
    func base64Encoding(plainData:Data)->String
    {
        let base64String = plainData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String
    }
    
    /**
     *   编码
     */
    func base64Encoding(plainString:String)->String
    {
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    /**
     *   解码
     */
    func base64Decoding(encodedString:String)->String
    {
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
}

extension String {
    
    /// 日期处理
    ///
    /// - Parameters:
    ///   - dateStr: <#dateStr description#>
    ///   - formatterStr: <#formatterStr description#>
    public static func dateFormatFromDateString(dateStr:String,formatterStr:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        if let date = formatter.date(from: dateStr) {
            let interval = Date().timeIntervalSince(date)
            if interval < TimeInterval(60) {
                return "刚刚"
            } else if (interval >= TimeInterval(60)) && (interval < TimeInterval(3600)) {
                return "\(Int(interval)/60)分钟前"
            } else {
                return dateStringFromDate(date: date)
            }
        }
        
        return ""
    }
    
    static func dateStringFromDate(date:Date) ->String {
        let calendar = Calendar.current
        var sets = Set<Calendar.Component>()
        sets.insert(.day)
        sets.insert(.month)
        sets.insert(.year)
        let componentIn = calendar.dateComponents(sets, from: date)
        let componentOut = calendar.dateComponents(sets, from: Date())
        
        if let day_in = componentIn.day,
            let day_out = componentOut.day,
            let month_in = componentIn.month,
            let month_out = componentOut.month,
            let year_in = componentIn.year,
            let year_out = componentOut.year {
             let formatter = DateFormatter()
            if day_in == day_out && month_in == month_out && year_in == year_out {
                formatter.dateFormat = "HH:mm"
            } else if year_in == year_out {
                formatter.dateFormat = "M月d日"
            } else {
                formatter.dateFormat = "yyyy年M月d日"
            }
            return formatter.string(from: date)
        }
        

        return ""
    }
}

