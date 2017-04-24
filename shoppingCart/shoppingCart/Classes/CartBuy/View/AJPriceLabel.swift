//
//  AJPriceLabel.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

class AJPriceLabel: UILabel {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: CGPoint(x: 0, y: rect.height * 0.5))
        ctx?.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.5))
        ctx?.strokePath()
    }

}
