//
//  AJShoppingViewController.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

class AJShoppingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        //设置UI
        presentingUI()
    }
    
    func presentingUI() {
        title = "阿俊购物车"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "clickBar")
    }
    
    func clickBar () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
