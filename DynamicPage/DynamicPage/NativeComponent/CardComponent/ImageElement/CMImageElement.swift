//
//  CMImageElement.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/15.
//  Copyright © 2019 YCM. All rights reserved.
//  纯图片布局

import UIKit
import Kingfisher

class CMImageElement: CMBaseElement {
    var imageUrl:String? {
        didSet {
            setupImageViewImage(imageUrl: imageUrl)
        }
    }
    
    private lazy var imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    //MARK : 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBannerCell()
        layoutConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: 私有方法
    private func setupBannerCell() {
        addSubview(imageView)
    }
    
    private func layoutConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    
    private func setupImageViewImage(imageUrl:String?) {
        
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: UIImage.imageWithColor(color: spaceColor), options: [.fromMemoryCacheOrRefresh,.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    override class func cell(collectView:UICollectionView,indexPath:IndexPath) -> CMImageElement? {
        return collectView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? CMImageElement
    }
    
    class func element(collectView:UICollectionView,indexPath:IndexPath,model:CMElementModel) -> CMImageElement {
        let element = cell(collectView: collectView, indexPath: indexPath)
        element?.setupImageViewImage(imageUrl: model.imageUrl)
        return element ?? CMImageElement()
    }
    
    override class func identifier() -> String{
        return "CMImageElement.cell"
    }
}
