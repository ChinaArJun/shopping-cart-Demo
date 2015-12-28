//
//  AJShoppingCell.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//  自定义cell

import UIKit

protocol AJShoppingCellDelegate : NSObjectProtocol {
    
    func shopping(shopping:AJShoppingCell ,button: UIButton ,label: UILabel)
//    func shoppingCalculate(CellBtn:UIButton)
    func shoppingCalculate()
}

class AJShoppingCell: UITableViewCell {
    
    
    //数据模型
    var addGoodArray : AJGoodModel? {
        didSet {
            //为当前子属性赋值
            selectButton.selected = addGoodArray!.selected
            
            amountLabel.text = "\(addGoodArray!.count)"
            
            if let iconName = addGoodArray?.iconName {
                iconView.image = UIImage(named: iconName)
            }
            
            if let title = addGoodArray?.title {
                titleLabel.text = title
            }
            
            if let newPrice = addGoodArray?.newPrice {
                newPriceLabel.text = newPrice
            }
            
            if let oldPrice = addGoodArray?.oldPrice {
                oldPriceLabel.text = oldPrice
            }
            
            //重新布局更新frame
            layoutIfNeeded()
        }
    }
    
    //代理协议
    weak var delegate: AJShoppingCellDelegate?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //创建UI属性
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //显示UI界面
    func prepareUI () {
        
        // 添加子控件
        addSubview(selectButton)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(newPriceLabel)
        addSubview(oldPriceLabel)
        addSubview(addAndsubtraction)
        
        //将加减号按钮和数量添加到 addAndsubtraction
        addAndsubtraction.addSubview(subtractButton)
        addAndsubtraction.addSubview(amountLabel)
        addAndsubtraction.addSubview(addButton)
        
        
        //约束子控件
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(42)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.top.equalTo(contentView.snp_top).offset(12)
        }
        
        newPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_top).offset(5)
            make.right.equalTo(-12)
        }
        
        oldPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newPriceLabel.snp_bottom).offset(5)
            make.right.equalTo(-12)
        }
        
        addAndsubtraction.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(120)
            make.top.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        subtractButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        amountLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(30)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        addButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
    }
    
    
    // MARK: - 按钮的点击事件
    //选择按钮的点击
    @objc private func chooseClick(CellBtn: UIButton) {
        
        print("1111:\(CellBtn.selected)--- \(!CellBtn.selected)")
        CellBtn.selected  = !CellBtn.selected
//        print("2222:\(CellBtn.selected)--- \(!CellBtn.selected)")
        
        addGoodArray?.selected = CellBtn.selected
        
// MARK: - 选择按钮的点击暂时有错误
        delegate?.shoppingCalculate()
//        delegate?.shoppingCalculate(button:button)
    }
    
    //商品数量按钮的点击
    @objc private func subtractClick(btn: UIButton) {
        
        delegate?.shopping(self, button: btn, label: amountLabel)
        
    }
    
    
    // MARK: - 数据懒加载
    ///选择按钮
    private lazy var selectButton: UIButton = {
       let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_p"), forState: UIControlState.Selected)
        selectButton.addTarget(self, action: "chooseClick:", forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.sizeToFit()
        return selectButton
    }()
    
    
    
    
    ///商品图片
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        //对图片进行裁剪
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    //商品的标题
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        
        return title
    }()
    
    ///新价格的标签
    private lazy var newPriceLabel: UILabel = {
        let newPriceLabel = UILabel()
        newPriceLabel.textColor = UIColor.redColor()
        return newPriceLabel
    }()
    
    ///商品旧价格标签  自定义Label
    private lazy var  oldPriceLabel: AJPriceLabel = {
    
        let old = AJPriceLabel()
        
        old.textColor = UIColor.grayColor()
        
        return old
    }()
    
    /// 加减操作的View
    private lazy var addAndsubtraction: UIView = {
       let view = UIView()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    
    /// 减号按钮
    private lazy var subtractButton: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.tag = 10
        btn.setBackgroundImage(UIImage(named: "jian_icon"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "subtractClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /// 加号按钮
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        
        btn.tag = 11
        btn.setBackgroundImage(UIImage(named: "add_icon"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "subtractClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    ///商品显示的数量
    private lazy var amountLabel: UILabel = {
       
        let label  = UILabel()
        //设置为剧中
        label.textAlignment = NSTextAlignment.Center
        return label
    }()

}














