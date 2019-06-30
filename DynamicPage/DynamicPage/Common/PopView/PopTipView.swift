//
//  PopTipView.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/2/28.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  提示内容弹框类型

import UIKit

class PopTipView: UIView {

    /// 是否有标题栏的样式
    fileprivate lazy var isHasTitle:Bool = true
    // MARK: 懒加载
    
    /// 弹框
    lazy var popView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let tipTitle = UILabel()
        tipTitle.text = "提示"
        tipTitle.textAlignment = .center
        tipTitle.textColor = themeTintColor
        tipTitle.font = UIFont.defaultCustomFont(30.0.cgFloat)
        
        let line = UIView()
        line.backgroundColor = themeTintColor
        
        if isHasTitle {
         
            view.addSubview(tipTitle)
            
            tipTitle.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(view.snp.top).offset(15)
                make.height.equalTo(21)
            })
            
         
            view.addSubview(line)
            
            line.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(tipTitle.snp.bottom).offset(15)
                make.height.equalTo(1)
            })
        }
        
        let confirmButton = UIButton(type: .custom)
        confirmButton.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white), for: .normal)
        confirmButton.setTitleColor(themeTintColor, for: .normal)
        confirmButton.titleLabel?.font = UIFont.defaultCustomFont(30.0.cgFloat)
        confirmButton.setTitle("知道了", for: .normal)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonClick(_:)), for: .touchUpInside)
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints({ (make) in
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(100.cgFloat)
        })
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(topLine)
        
        topLine.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.equalTo(1)
        })
        
        view.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(view.snp.left).offset(20.cgFloat)
            make.right.equalTo(view.snp.right).offset(-20.cgFloat)
            if isHasTitle {
                make.top.equalTo(line.snp.bottom).offset(20.cgFloat)
            } else {
                make.top.equalTo(view.snp.top).offset(40.cgFloat)
            }
            make.bottom.equalTo(topLine.snp.top).offset(-20.cgFloat)
        })
        
        return view
    }()
    
    /// 提示标签
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultCustomFont(30.0.cgFloat)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.colorWithHex(rgb: 0x333333)
        return label
    }()
    
    // MARK: 属性
    var completeBlock:(()->())?
    
    // MARK: 构造方法
    convenience init(_ msg:String,isHasTitle:Bool, block: @escaping () ->()) {
        self.init()
        
        self.isHasTitle = isHasTitle
        setupPopTopView()
        layoutConstraint()
        
        tipLabel.text = msg
        completeBlock = { () in
            block()
        }
        
    }
    // MARK: 私有方法
    
    /// 初始化Popview
    fileprivate func setupPopTopView() {
          backgroundColor = UIColor(white: 0.1, alpha: 0.3)
          addSubview(popView)
        
        popView.layer.cornerRadius = 10.0.cgFloat
        popView.layer.masksToBounds = true
    }
    
    fileprivate func layoutConstraint() {
        
        frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        
        popView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(560.cgFloat)
            
            if isHasTitle {
                make.height.equalTo(400.cgFloat)
            } else {
                make.height.equalTo(360.cgFloat)
            }
        }
    }
    
    // MARK: 外部接口
    
    /// 显示
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    /// 消失
    func dismiss() {
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        for (_,view) in self.subviews.enumerated() {
            view.removeFromSuperview()
        }
        
        self.removeFromSuperview()
    }

    // MARK: 内部响应
    
    /// 确认按钮点击
    ///
    /// - Parameter button: <#button description#>
    @objc fileprivate func confirmButtonClick(_ button:UIButton) {
        button.isHighlighted = false
        dismiss()
    
        if let block = completeBlock {
            block()
        }
    }
}
