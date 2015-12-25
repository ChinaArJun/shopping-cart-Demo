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
        navigationItem.title = "商品列表"
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
    
    
    
    /// 购物车按键的点击， model 到控制器
    @objc private func cartClick () {
        
        let controller = AJShoppingViewController()
        controller.addGoodArray = addGoodArray
        //跳转控制器
        presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    
    //MARK: - 属性懒加载
    
    ///显示购物车数量Label
    lazy var amontCart : UILabel = {
        var label = UILabel()
        label.textColor = UIColor.redColor()
        label.backgroundColor = UIColor.whiteColor()
        label.text = "\(self.goodArray.count)"
        label.font = UIFont.systemFontOfSize(11)
        //画一个圆圈
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = 7.5
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.redColor().CGColor
        label.hidden = true
        
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
        
        guard let indexPath = cartTableView.indexPathForCell(cell) else {
            //没有创建数据就直接返回
            return
        }
        //获得当前的数据
        let redata = goodArray[indexPath.row]
        
        //添加到已购买数组之中
        addGoodArray.append(redata)
        
        //重新计算iconView的frame值
        //获取当前行的frame值
        var rect = cartTableView.rectForRowAtIndexPath(indexPath)
        
        rect.origin.y -= cartTableView.contentOffset.y
        var headRect = icon.frame
        headRect.origin.y = rect.origin.y + headRect.origin.y - 64
        startAnimation(headRect, iconView: icon)
    }
}

// MARK: - 商品图片抛入购物车的动画效果
extension AJToViewController  {
    
    //开始动画
    private func startAnimation(rect: CGRect ,iconView:UIImageView) {
        if layer == nil {
            //创建核心动画
            layer = CALayer()
            layer?.contents = iconView.layer.contents
            layer?.contentsGravity = kCAGravityResizeAspectFill
            layer?.bounds = rect
            layer?.cornerRadius = CGRectGetHeight(layer!.bounds) * 0.5
            layer?.masksToBounds = true
            layer?.position = CGPoint(x: iconView.center.x, y: CGRectGetMaxY(rect))
            UIApplication.sharedApplication().keyWindow?.layer.addSublayer(layer!)
            path = UIBezierPath()
            path?.moveToPoint(layer!.position)
            path?.addQuadCurveToPoint(CGPoint(x: screenSize.width - 25, y: 35), controlPoint: CGPoint(x: screenSize.width * 0.5, y: 80))
            
        }
        //组动画
        groupAnimation()
    }
    
    //组动画,侦动画抛入购物车，并且放大，缩小图层增加懂效果
    private func groupAnimation() {
        
        // 开始动画禁用tableview交互
        cartTableView.userInteractionEnabled = false
        
        // 帧动画
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path!.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        
        // 放大动画
        let bigAnimation = CABasicAnimation(keyPath: "transform.scale")
        bigAnimation.duration = 0.5
        bigAnimation.fromValue = 1
        bigAnimation.toValue = 2
        bigAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        // 缩小动画
        let smallAnimation = CABasicAnimation(keyPath: "transform.scale")
        smallAnimation.beginTime = 0.5
        smallAnimation.duration = 1.5
        smallAnimation.fromValue = 2
        smallAnimation.toValue = 0.3
        smallAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // 组动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, bigAnimation, smallAnimation]
        groupAnimation.duration = 2
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        layer?.addAnimation(groupAnimation, forKey: "groupAnimation")
    }
    
    /**
     动画结束后做一些操作
     */
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        // 如果动画是我们的组动画，才开始一些操作
        if anim == layer?.animationForKey("groupAnimation") {
            
            // 开启交互
            cartTableView.userInteractionEnabled = true
            
            // 隐藏图层
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
            layer = nil
            
            // 如果商品数大于0，显示购物车里的商品数量
            if self.addGoodArray.count > 0 {
                amontCart.hidden = false
            }
            
            // 商品数量渐出
            let goodCountAnimation = CATransition()
            goodCountAnimation.duration = 0.25
            amontCart.text = "\(self.addGoodArray.count)"
            amontCart.layer.addAnimation(goodCountAnimation, forKey: nil)
            
            // 购物车抖动
            let cartAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            cartAnimation.duration = 0.25
            cartAnimation.fromValue = -5
            cartAnimation.toValue = 5
            cartAnimation.autoreverses = true
            cartBtn.layer.addAnimation(cartAnimation, forKey: nil)
        }
    }
}










