//
//  AJShoppingCell.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//  自定义cell

import UIKit
import SnapKit

protocol AJShoppingCellDelegate : NSObjectProtocol {
    
    func shopping(_ shopping:AJShoppingCell ,button: UIButton ,label: UILabel)
//    func shoppingCalculate(CellBtn:UIButton)
    func shoppingCalculate()
}

class AJShoppingCell: UITableViewCell {
    
    
    //数据模型
    var addGoodArray : AJGoodModel? {
        didSet {
            //为当前子属性赋值
            selectButton.isSelected = addGoodArray!.selected
            
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
        selectButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        iconView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(42)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(contentView.snp.top).offset(12)
        }
        
        newPriceLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.top).offset(5)
            make.right.equalTo(-12)
        }
        
        oldPriceLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(newPriceLabel.snp.bottom).offset(5)
            make.right.equalTo(-12)
        }
        
        addAndsubtraction.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(120)
            make.top.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        subtractButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        amountLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(30)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        addButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
    }
    
    
    // MARK: - 按钮的点击事件
    //选择按钮的点击
    @objc fileprivate func chooseClick(_ CellBtn: UIButton) {
        
        print("1111:\(CellBtn.isSelected)--- \(!CellBtn.isSelected)")
        CellBtn.isSelected  = !CellBtn.isSelected
//        print("2222:\(CellBtn.selected)--- \(!CellBtn.selected)")
        
        addGoodArray?.selected = CellBtn.isSelected
        
// MARK: - 选择按钮的点击暂时有错误
        delegate?.shoppingCalculate()
//        delegate?.shoppingCalculate(button:button)
    }
    
    //商品数量按钮的点击
    @objc fileprivate func subtractClick(_ btn: UIButton) {
        
        delegate?.shopping(self, button: btn, label: amountLabel)
        
    }
    
    
    // MARK: - 数据懒加载
    ///选择按钮
    fileprivate lazy var selectButton: UIButton = {
       let selectButton = UIButton(type: UIButtonType.custom)
        selectButton.setImage(UIImage(named: "check_n"), for: UIControlState())
        selectButton.setImage(UIImage(named: "check_p"), for: UIControlState.selected)
        selectButton.addTarget(self, action: #selector(self.chooseClick(_:)), for: UIControlEvents.touchUpInside)
        selectButton.sizeToFit()
        return selectButton
    }()
    
    
    
    
    ///商品图片
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        //对图片进行裁剪
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    //商品的标题
    fileprivate lazy var titleLabel: UILabel = {
        let title = UILabel()
        
        return title
    }()
    
    ///新价格的标签
    fileprivate lazy var newPriceLabel: UILabel = {
        let newPriceLabel = UILabel()
        newPriceLabel.textColor = UIColor.red
        return newPriceLabel
    }()
    
    ///商品旧价格标签  自定义Label
    fileprivate lazy var  oldPriceLabel: AJPriceLabel = {
    
        let old = AJPriceLabel()
        
        old.textColor = UIColor.gray
        
        return old
    }()
    
    /// 加减操作的View
    fileprivate lazy var addAndsubtraction: UIView = {
       let view = UIView()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return view
    }()
    
    /// 减号按钮
    fileprivate lazy var subtractButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = 10
        btn.setBackgroundImage(UIImage(named: "jian_icon"), for: UIControlState())
        btn.addTarget(self, action: #selector(self.subtractClick(_:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    /// 加号按钮
    fileprivate lazy var addButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        
        btn.tag = 11
        btn.setBackgroundImage(UIImage(named: "add_icon"), for: UIControlState())
        btn.addTarget(self, action: #selector(self.subtractClick(_:)), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    ///商品显示的数量
    fileprivate lazy var amountLabel: UILabel = {
       
        let label  = UILabel()
        //设置为剧中
        label.textAlignment = NSTextAlignment.center
        return label
    }()

}














