//
//  CMBannerCell.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/11.
//  Copyright © 2019 YCM. All rights reserved.
//  轮播图Cell

import UIKit

class CMBannerCell: UICollectionViewCell {
    var imageUrl:String? {
        didSet {
            setupPageViewImage(imageUrl: imageUrl)
        }
    }
    
    private lazy var pageView:UIImageView = {
        let view = UIImageView()
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
        addSubview(pageView)
        pageView.contentMode = .scaleToFill
    }
    
    private func layoutConstraint() {
        pageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    
    private func setupPageViewImage(imageUrl:String?) {
        pageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: UIImage.imageWithColor(color: spaceColor), options: [.fromMemoryCacheOrRefresh,.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    
    class func cell(collectView:UICollectionView,indexPath:IndexPath) -> CMBannerCell? {
        return collectView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? CMBannerCell
    }
    
    class func identifier() -> String{
        return "CMBannerView.cell"
    }
}
