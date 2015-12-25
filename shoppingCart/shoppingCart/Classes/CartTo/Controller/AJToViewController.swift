//
//  ToViewController.swift
//  shoppingCart
//
//  Created by 罗连喜 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

//屏幕的size
let screenSize = UIScreen.mainScreen().bounds.size

class AJToViewController: UIViewController {

    
    // MARK: - 属性
    ///商品模型数组
    private var goodArray = [AJGoodModel]()
    
    ///商品列表cell的重用标识
    private let goodLinstCell = "AJToTableViewCell"

    /// 已经添加进购物车的商品模型数组
    private var addGoodArray = [AJGoodModel]()
    
    ///贝塞尔曲线
    private var path : UIBezierPath?
    
    //自定义图层
    var layer: CALayer?
    
    //提示: 这个方法一般是用于初始化控件的一些数据，但是这个方法获得的frame并不一定准确，所以不建议在此约束控件
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化模型数组,制作一些假数据
        for i in 0..<10 {
            var dict = [String :AnyObject]()
            dict["iconName"] = "goodicon_\(i)"
            dict["title"] = "\(i)commodity"
            dict["desc"] = "这是第\(i)个商品"
            dict["newPrice"] = "20\(i)"
            dict["oldPrice"] = "30\(i)"
            
            //将字典转模型并添加到数组中
            goodArray.append(AJGoodModel(dict:dict))
        }
        
        //添加view
        addUiView()
    }

    //提示: 这个方法是当view已经显示后调用，我们在这里做view的约束比较准确
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
        
        //约束子控件
        layoutUI()
    }
    
    //添加view
    func addUiView() {
        navigationItem.title = "阿俊的购物车"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartBtn)
        //添加购物车
        navigationController?.navigationBar.addSubview(amontCart)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.view.addSubview(cartTableView)
        
        cartTableView.registerClass(AJToTableViewCell.self, forCellReuseIdentifier: goodLinstCell)
    }
    
     //约束子控件
    func layoutUI () {
        
        cartTableView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: CGSize(width: screenSize.width  , height: screenSize.height))
        amontCart.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        
        amontCart.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(10.5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
    

    
    /// 购物车按键的触发事件
    func cartClick () {
        
    }
    
    
    //MARK: - 属性懒加载
    
    ///显示购物车数量Label
    lazy var amontCart : UILabel = {
       var label = UILabel()
        label.textColor = UIColor.redColor()
        label.text = "\(self.goodArray.count)"
        label.font = UIFont.systemFontOfSize(11)
        
        return label
    }()
    
    ///当前的tableView
    lazy var cartTableView : UITableView = {
        var tableView = UITableView()
       
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    ///购物车按钮
    lazy var cartBtn : UIButton =  {
       var btn = UIButton()
        
        btn.setImage(UIImage(named: "button_cart"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "cartClick", forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        
        return btn
    }()
}

// MARK: - UITableView数据源和代理方法
extension AJToViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //缓存池中创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier(goodLinstCell) as! AJToTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.goodModel = goodArray[indexPath.row]
        
        // 代理的对象
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: - Cell点击的代理方法
extension AJToViewController : AJToTableViewCellDelegate {
    
    func clickTransmitData(cell: AJToTableViewCell, icon: UIImageView) {
        print("cell的点击")
    }
    
}












