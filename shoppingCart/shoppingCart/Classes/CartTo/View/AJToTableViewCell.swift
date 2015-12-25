//
//  AJToTableViewCell.swift
//  shoppingCart
//
//  Created by 阿俊 on 15/12/25.
//  Copyright © 2015年 罗连喜. All rights reserved.
//

import UIKit

//使用代理传输数据
protocol AJToTableViewCellDelegate :NSObjectProtocol {
    
    //代理方法
    func clickTransmitData(cell:AJToTableViewCell ,icon: UIImageView)
    
}

class AJToTableViewCell: UITableViewCell {

    // MARK: - 属性
    /// 商品模型
    var goodModel : AJGoodModel? {
        //属性监视
        didSet {
            if let iconName  = goodModel?.iconName {
                iconView.image = UIImage(named: iconName)
            }
            
            if let title = goodModel?.title {
                titleLabel.text = title
            }
            
            if let desc = goodModel?.desc {
                descLabel.text = desc
            }
            
            //已经点击就禁用,防止cell的重用
            addCarButton.selected = !goodModel!.alreadyAddShoppingCArt
            
            //重新布局
            layoutIfNeeded()
        }
    }
    
    //代理属性
    weak var delegate: AJToTableViewCellDelegate?
    
    //回调给控制器的商品图片
    var collBackIconView: UIImageView?
    
    //重写构造方法准备UI
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //准备UI
    func prepareUI () {
        //添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(addCarButton)
        
        //约束子控件
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(iconView.snp_right).offset(12)
            
        }
        
        
        descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(12)
            make.left.equalTo(iconView.snp_right).offset(12)
        }
        
        addCarButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(25)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        
    }
    
    
    /// 购买按键的点击  private私有方法
    @objc private func addCarButtonClick(btn:UIButton) {
        goodModel!.alreadyAddShoppingCArt = true
        
        btn.enabled = !goodModel!.alreadyAddShoppingCArt
        //传输值
        delegate?.clickTransmitData(self, icon: iconView)
        
    }
    
    
    // MARK: - 属性懒加载
    private lazy var iconView: UIImageView = {
       let iconView = UIImageView()
        //圆角
        iconView.layer.cornerRadius = 30
        //裁剪模式
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    //商品标题
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    //商品描述
    private lazy var descLabel: UILabel = {
        let descLabel  = UILabel()
        descLabel.textColor = UIColor.grayColor()
       return descLabel
    }()
    
    //添加按钮
    private lazy var addCarButton: UIButton = {
       
        let addCarButton = UIButton(type: UIButtonType.Custom)
        addCarButton.setBackgroundImage(UIImage(named: "button_add_cart"), forState: UIControlState.Normal)
        addCarButton.setTitle("购买", forState: UIControlState.Normal)
        //按钮的点击事件
        addCarButton.addTarget(self, action: "addCarButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return addCarButton
    }()

    
    
    
    
    
    
}
