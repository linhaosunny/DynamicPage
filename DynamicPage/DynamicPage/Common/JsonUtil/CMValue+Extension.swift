//
//  CMValue+Extension.swift
//  ChattingManage
//
//  Created by sunshine.lee on 2019/5/17.
//  Copyright © 2019 YCM. All rights reserved.
//

import Foundation
import UIKit


let fixes = UIScreen.main.scale * 0.5 == 1.0 ? CGFloat(1.0) : CGFloat(1.1)

let scale = UIScreen.main.bounds.height < 576.0 ? CGFloat(0.45) * fixes  : CGFloat(0.5) * fixes

extension Int {
    var fixScale: Int {
        return Int(CGFloat(self) * scale)
    }
    
    
    var cgFloat: CGFloat {
        return CGFloat(self) * scale
    }
    
    var scaleCGFloat:CGFloat {
        return CGFloat(self) * CGFloat(0.5) * fixes
    }
}

extension Float {
    var fixScale: Float {
        return Float(CGFloat(self) * scale)
    }
    
    var cgFloat:CGFloat {
        return CGFloat(self) * scale
    }
    
    var scaleCGFloat:CGFloat {
        return CGFloat(self) * CGFloat(0.5) * fixes
    }
}


extension Double {
    var fixScale: Double {
        return Double(CGFloat(self) * scale)
    }
    
    
    var cgFloat:CGFloat {
        return CGFloat(self) * scale
    }
    
    var scaleCGFloat:CGFloat {
        return CGFloat(self) * CGFloat(0.5) * fixes
    }
}

extension CGFloat {
    var fixScale: CGFloat {
        return self * scale
    }
    
    var cgFloat:CGFloat {
        return CGFloat(self) * scale
    }
    
    var scaleCGFloat:CGFloat {
        return CGFloat(self) * CGFloat(0.5) * fixes
    }
    
    var orignValue:CGFloat {
        return CGFloat(self) / scale
    }
}
