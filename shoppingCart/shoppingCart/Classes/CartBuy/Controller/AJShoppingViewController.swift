//
//  AJShoppingViewController.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

class AJShoppingViewController: UIViewController {
    
    // MARK: - 属性
    /// 已经添加进购物车的商品模型数组，初始化
    var addGoodArray: [AJGoodModel]? {
        //属性监视
        didSet {
            
        }
    }
    
    //购买商品的总金额
    var price: Float = 0.00
    
    //商品列表cell的重用标示符
    private let shoppingCarCellIdntifier  = "shoppingCarCellIdntifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        //设置UI
        presentingUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //约束
        layoutUI()
    }
    
    // MARK:- 设置UI
    func presentingUI() {
        title = "阿俊购物车"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "clickBar")
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem?.tintColor = UIColor.orangeColor()
        showCartTableView.rowHeight = 80
        
        //注册cell
        showCartTableView.registerClass(AJShoppingCell.self, forCellReuseIdentifier: shoppingCarCellIdntifier)
        
        //添加子控件
        view.addSubview(showCartTableView)
        view.addSubview(bottomView)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
        
        //判断是否需要全选中
        for model in addGoodArray! {
            if model.selected != true {
                //只要有一个不等于就不全选中
                buyButton.selected = false
                break
            }
        }
    }
    
    //约束UI
    func layoutUI() {
        
        //约束子控件
        showCartTableView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-49)
        }
        //底部选择条
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomView.snp_center)
        }
        
        buyButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(9)
            make.width.equalTo(88)
            make.height.equalTo(30)
        }
        
    }
    
    //返回按钮的点击
    func clickBar () {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    // MARK: - 数据懒加载
    lazy var showCartTableView : UITableView = {
        let tableView = UITableView()
        
        //指定数据源和代理
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //底部视图
    lazy var bottomView : UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor  = UIColor.whiteColor()
        return bottomView
    }()
    
    //底部多选、反选的按钮
    lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_p"), forState: UIControlState.Selected)
        selectButton.setTitle("多选\\反选", forState: UIControlState.Normal)
        selectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        selectButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        selectButton.addTarget(self, action: "didSelectButton:", forControlEvents: UIControlEvents.TouchUpInside)
        //默认是已经选择的状态
        selectButton.selected = true
        selectButton.sizeToFit()
        
        return selectButton
    }()
    
    //底部总价格的Label
    lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        let attributeText = NSMutableAttributedString(string: "总价格\(self.price)0")
        attributeText.setAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(5, attributeText.length - 5))
        
        label.attributedText = attributeText
        label.sizeToFit()
        return label
    }()
    
    //点击付款的按钮
    lazy var buyButton : UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setTitle("付款", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "button_add_cart"), forState: UIControlState.Normal)
        //裁剪
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
}

// tableView扩展
extension AJShoppingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //如果没有数据就为0行
        return addGoodArray!.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(shoppingCarCellIdntifier, forIndexPath: indexPath) as! AJShoppingCell
        /*
        属性赋值时，我们发现需要需要再自定义一个tableViewCell来接收模型的数据
        cell.goodModel = addGoodArray![indexPath.row]
        */
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.addGoodArray = addGoodArray![indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
}

///cell点击的代理方法
extension AJShoppingViewController : AJShoppingCellDelegate {
    
    //商品数量按钮的点击
    func shopping(shopping: AJShoppingCell, button: UIButton, label: UILabel) {
        
        //获得点击当前的cell
        guard let indexPath = showCartTableView.indexPathForCell(shopping) else {
            return
        }
        
        //获得当前数据模型
        let data = addGoodArray![indexPath.row]
        
        if button.tag == 10 {
            
            if data.count < 1 {
                //count 的数量不能为0
                return
            }
            
            data.count--
            label.text = "\(data.count)"
            
        }else
        {
            data.count++
            label.text = "\(data.count)"
        }
        //重新计算总价格
        reCalculateGoodCount()
    }
    
    func shoppingCalculate() {
        reCalculateGoodCount()
    }
}

extension AJShoppingViewController {
    
    ///重新计算商品的数量
    private func reCalculateGoodCount() {
        //遍历模型
        for model in addGoodArray! {
            //计算选中的商品
            if model.selected == true {
                price += Float(model.count) * (model.newPrice! as NSString).floatValue
            }
            
        }
        
        //赋值价格
        let  attributeText = NSMutableAttributedString(string: "总共价格: \(self.price)0")
        
            attributeText.setAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(5, attributeText.length - 5))
        totalPriceLabel.attributedText = attributeText
        
        //清空price
        price = 0
        
        showCartTableView.reloadData()
    }
    
    @objc private func didSelectButton(btn:UIButton) {
        
        btn.selected = !btn.selected
        
        for model in addGoodArray! {
            model.selected = btn.selected
        }
        
        //重新计算价格
        reCalculateGoodCount()
    }
}






