//
//  CMBaseElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/16.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMBaseElement: UICollectionViewCell {
    
    // MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cell(collectView:UICollectionView,indexPath:IndexPath) -> CMBaseElement? {
        return collectView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? CMBaseElement
    }
    
    class func element(collectView:UICollectionView,indexPath:IndexPath) -> CMBaseElement {
        let element = cell(collectView: collectView, indexPath: indexPath)
        
        return element ?? CMBaseElement()
    }
    
    class func identifier() -> String{
        return "CMBaseElement.cell"
    }
}
