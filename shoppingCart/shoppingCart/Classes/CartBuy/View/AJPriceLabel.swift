//
//  AJPriceLabel.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

class AJPriceLabel: UILabel {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(ctx, 0, rect.height * 0.5)
        CGContextAddLineToPoint(ctx, rect.width, rect.height * 0.5)
        CGContextStrokePath(ctx)
    }

}
