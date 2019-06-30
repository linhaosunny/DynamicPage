//
//  CMJsonUtil.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/16.
//  Copyright © 2019 YCM. All rights reserved.
// 数据转换工具

import UIKit
import HandyJSON
struct CMJsonUtil {
    
    /**
     *  Json转对象
     */
    static func jsonToModel(_ jsonStr: String,_ modelType: HandyJSON.Type) -> CMBaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            print("jsonoModel:字符串为空")
            return CMBaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as? CMBaseModel ?? CMBaseModel()
        
    }
    
    /**
     *  Json转数组对象
     */
    static func jsonArrayToModel<T: HandyJSON>(_ jsonArrayStr: String, _ modelType: T.Type) ->[T]? {
        var modelArray:[T] = []
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            print("jsonToModelArray:字符串为空")
            return modelArray
        }
        
        guard let data = jsonArrayStr.data(using: String.Encoding.utf8) else {
            return modelArray
        }
        
        var peoplesArray: [AnyObject]?
        do {
            peoplesArray = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        } catch {
            return modelArray
        }
        
        guard let peoplesArrayJ = peoplesArray else {
            return modelArray
        }
        
        for people in peoplesArrayJ {
            guard let peopleZ = people as? [String : Any] else {
                print("peopleZ转化成 [String : Any]类型失败")
                continue
            }
            guard let model = dictionaryToModel(peopleZ, modelType) else {
                continue
            }
            modelArray.append(model)
        }
        return modelArray
        
    }
    
    /**
     *  数组转数组对象
     */
    static func arrayToModels<T: HandyJSON>(_ array: [Any]?, _ modelType: T.Type) -> [T] {
        var modelArray:[T] = []
        guard let array = array, array.count != 0 else {
            print("arrayToModels: 数组元素为0或数组为空")
            return modelArray
        }
        
        for dic in array {
            guard let dicJ = dic as? [String : Any] else {
                print("dic转化成 [String : Any]类型失败")
                continue
            }
            guard let model = dictionaryToModel(dicJ, modelType) else {
                continue
            }
            modelArray.append(model)
        }
        return modelArray
    }
    
    /**
     *  字典转对象
     */
    static func dictionaryToModel<T: HandyJSON>(_ dictionStr:[String: Any]?,_ modelType: T.Type) -> T? {
        if dictionStr?.count == 0 {
            print("dictionaryToModel:字符串为空")
            return nil
        }
        return modelType.deserialize(from: dictionStr)
    }
    
    /**
     *  对象转JSON
     */
    static func modelToJson(_ model: CMBaseModel?) -> String {
        if model == nil {
            print("modelToJson:model为空")
            return ""
        }
        return model?.toJSONString() ?? ""
    }
    
    /**
     *  对象转字典
     */
    static func modelToDictionary(_ model: CMBaseModel?) -> [String: Any] {
        if model == nil {
            print("modelToJson:model为空")
            return [:]
        }
        return model?.toJSON() ?? [:]
    }
    
    /**
     *  对象数组转字典数组
     */
    static func modelToDictionarys(_ models: [CMBaseModel]?) -> [[String: Any]] {
        var dicArr = [[String: Any]]()
        guard let modelsJ = models else {
            print("modelToJson:models为空")
            return dicArr
        }
        
        for model in modelsJ {
            if let dic = model.toJSON() {
                dicArr.append(dic)
            }
        }
        
        return dicArr
    }
    
    /**
     字典转换为JSONString
     
     - parameter dictionary: 字典参数
     
     - returns: JSONString
     */
    static func getJSONStringFromDictionary(dictionary: Dictionary<String, Any>) -> String {
        
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
     
            return ""
        }
        guard let data : Data = try? JSONSerialization.data(withJSONObject: dictionary, options:  []) else {
            return ""
        }
        
        let JSONString = String(data: data, encoding: String.Encoding.utf8)
        return JSONString ?? ""
    }
}
