//
//  CMUIView+Extension.swift
//  ChattingManage
//
//  Created by 李莎鑫 on 2019/5/18.
//  Copyright © 2019 YCM. All rights reserved.
//

import UIKit

extension UIView {
    
    func isDisplayedInSuperView() -> Bool {
        guard let view = superview else {
            return false
        }
        
        if view.isHidden {
            return false
        }
        
        let superRect = view.convert(view.frame, to: nil)
        let rect = self.convert(self.frame, from: nil)
        if rect.isEmpty || rect.isNull {
            return false
        }
        
        if self.isHidden {
            return false
        }
        
        if self.superview == nil {
            return false
        }
        
        if __CGSizeEqualToSize(rect.size, CGSize.zero) {
            return false
        }
        
        let intersectionRect = superRect.intersection(rect)
        
        if intersectionRect.isEmpty || intersectionRect.isNull {
            return false
        }
        
        return true
    }
    
    func isDisplayedInScreen() -> Bool {
        
        let screenRect = UIScreen.main.bounds
        let rect = self.convert(self.frame, from: nil)
        if rect.isEmpty || rect.isNull {
            return false
        }
        
        if self.isHidden {
            return false
        }
        
        if self.superview == nil {
            return false
        }
        
        if __CGSizeEqualToSize(rect.size, CGSize.zero) {
            return false
        }
        
        let intersectionRect = screenRect.intersection(rect)
        
        if intersectionRect.isEmpty || intersectionRect.isNull {
            return false
        }
        
        return true
    }
}
