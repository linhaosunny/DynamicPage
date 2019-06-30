//
//  CMMultlineTextElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/16.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

class CMMultlineTextElement: CMBaseElement {
    
    fileprivate lazy var label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMultlineTextElement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 私有方法
    fileprivate func setupMultlineTextElement() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override class func cell(collectView:UICollectionView,indexPath:IndexPath) -> CMMultlineTextElement? {
        return collectView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? CMMultlineTextElement
    }
    
    override class func element(collectView:UICollectionView,indexPath:IndexPath) -> CMMultlineTextElement {
        let element = cell(collectView: collectView, indexPath: indexPath)
        
        return element ?? CMMultlineTextElement()
    }
    
    override class func identifier() -> String{
        return "CMMultlineTextElement.cell"
    }
}
