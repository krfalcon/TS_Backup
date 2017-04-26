//
//  FoodView.swift
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

import UIKit

let incomingTag = 0

@objc protocol FoodViewDelegate {
    func foodViewDidTappedFoodButton(_ parameter: NSDictionary)
    func foodViewDidRefresh()
}

class FoodView: TempletView {
    weak var delegate: FoodViewDelegate?
    var foodListArray: NSArray!
    var foodScrollView: UIScrollView!
    
    override func initView() {
        foodScrollView = UIScrollView(frame: CGRect(x: 0, y: titleHeight, width: frame.width, height: frame.height - titleHeight))
        foodScrollView.showsVerticalScrollIndicator = false
        self.addSubview(foodScrollView)
        
        foodScrollView.addHeader(withTarget: self, action: #selector(FoodView.refresh))
        foodScrollView.headerBeginRefreshing()
    }
    
    func createFoodList() {
        for i: Int in 0 ..< foodListArray.count{
            let foodEntity: ShopEntity = (foodListArray.object(at: i)) as! ShopEntity
            
            let foodView: UIView = UIView(frame: CGRect(x: 0, y: 30 * scale + CGFloat(i) * 125 * scale, width: frame.width, height: 100 * scale))
            foodView.backgroundColor = UIColor(red: 255.0 / 255.0, green: 230.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
            foodScrollView.addSubview(foodView)
            
            let foodImage: MDIncrementalImageView = MDIncrementalImageView(frame: CGRect(x: 10 * scale, y: 10 * scale, width: 110 * scale, height: 80 * scale))
            foodImage.setImageUrl(URL(string: foodEntity.logoUrl))
            foodView.addSubview(foodImage)
            
            let titleView: UIView = UIView(frame: CGRect(x: 130 * scale, y: -15 * scale, width: frame.width - (130 - 15) * scale , height: 30 * scale))
            titleView.layer.cornerRadius = titleView.frame.height / 2
            titleView.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
            foodView.addSubview(titleView)
            
            let titleLabel: UILabel = UILabel(frame: CGRect(x: titleView.frame.height / 2, y: 0, width: 95 * scale, height: 30 * scale))
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.text = foodEntity.chName
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18 * scale)
            titleView.addSubview(titleLabel)
            
            let nameLabel: UILabel = UILabel(frame: CGRect(x: titleView.frame.height / 2 + 100 * scale, y: 0, width: titleView.frame.width - 160 * scale, height: 30 * scale))
            nameLabel.backgroundColor = UIColor.clear
            nameLabel.text = foodEntity.enName
            nameLabel.textColor = UIColor.white
            nameLabel.font = UIFont.systemFont(ofSize: 16 * scale)
            titleView.addSubview(nameLabel)
            
            let middleLine: UIView = UIView(frame: CGRect(x: self.frame.width - 110 * scale, y: 35 * scale, width: 0.5, height: 50 * scale))
            middleLine.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
            foodView.addSubview(middleLine)
            
            let peopleImage: UIImageView = UIImageView(frame: CGRect(x: 130 * scale, y: 40 * scale, width: 40 * scale , height: 40 * scale))
            peopleImage.contentMode = UIViewContentMode.scaleAspectFit
            peopleImage.image = UIImage(named: "ShopListFood_People")
            foodView.addSubview(peopleImage)
            
            if foodEntity.open {
                let openLabel: UILabel = UILabel(frame: CGRect(x: titleView.frame.width - 45 * scale, y: 2.5 * scale, width: 25 * scale, height: 25 * scale))
                openLabel.layer.cornerRadius = openLabel.frame.height / 2
                openLabel.layer.backgroundColor = UIColor.white.cgColor
                openLabel.text = "开"
                openLabel.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                openLabel.textAlignment = NSTextAlignment.center
                openLabel.font = UIFont.systemFont(ofSize: 16 * scale)
                titleView.addSubview(openLabel)
                
                switch foodEntity.valid {
                case 1:
                    let missLabel: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 35 * scale, width: 75 * scale, height: 40 * scale))
                    missLabel.text = "到你啦"
                    missLabel.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    missLabel.textAlignment = NSTextAlignment.center
                    missLabel.font = UIFont.systemFont(ofSize: 20 * scale)
                    foodView.addSubview(missLabel)
                    
                    let reserveLabel: UILabel = UILabel(frame: CGRect(x: foodView.frame.width - 95 * scale, y: 40 * scale, width: 80 * scale, height: 40 * scale))
                    reserveLabel.layer.cornerRadius = reserveLabel.frame.height / 2
                    reserveLabel.layer.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1).cgColor
                    reserveLabel.text = "取号"
                    reserveLabel.textColor = UIColor.white
                    reserveLabel.textAlignment = NSTextAlignment.center
                    reserveLabel.font = UIFont.boldSystemFont(ofSize: 20 * scale)
                    foodView.addSubview(reserveLabel)
                case 0:
                    let haiyou: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 35 * scale, width: 75 * scale, height: 20 * scale))
                    haiyou.text = "还有"
                    haiyou.textColor = UIColor.gray
                    haiyou.font = UIFont.systemFont(ofSize: 16 * scale)
                    foodView.addSubview(haiyou)
                    
                    let zhuo: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 35 * scale, width: 75 * scale, height: 20 * scale))
                    zhuo.text = "桌"
                    zhuo.textColor = UIColor.gray
                    zhuo.textAlignment = NSTextAlignment.right
                    zhuo.font = UIFont.systemFont(ofSize: 16 * scale)
                    foodView.addSubview(zhuo)
                    
                    let yijiaodao: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 65 * scale, width: 75 * scale, height: 20 * scale))
                    yijiaodao.text = "已叫到"
                    yijiaodao.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    yijiaodao.font = UIFont.systemFont(ofSize: 12 * scale)
                    foodView.addSubview(yijiaodao)
                    
//                    let hao: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 65 * scale, width: 75 * scale, height: 20 * scale))
//                    hao.text = "号"
//                    hao.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
//                    hao.textAlignment = NSTextAlignment.Right
//                    hao.font = UIFont.systemFontOfSize(12 * scale)
//                    foodView.addSubview(hao)
                    
                    let callingNumber: UILabel = UILabel(frame: CGRect(x: 230 * scale, y: 65 * scale, width: 75 * scale, height: 20 * scale))
                    callingNumber.text = foodEntity.calling != "<null>" && foodEntity.calling != "" ? foodEntity.calling : "0"
                    callingNumber.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    callingNumber.textAlignment = NSTextAlignment.left
                    callingNumber.font = UIFont.systemFont(ofSize: 17 * scale)
                    foodView.addSubview(callingNumber)
                    
                    let remainingNumber: UILabel = UILabel(frame: CGRect(x: 230 * scale, y: 35 * scale, width: 75 * scale, height: 20 * scale))
                    remainingNumber.text = foodEntity.remaining != "<null>" && foodEntity.remaining != "" ? foodEntity.remaining : "0"
                    remainingNumber.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    remainingNumber.textAlignment = NSTextAlignment.left
                    remainingNumber.font = UIFont.systemFont(ofSize: 17 * scale)
                    foodView.addSubview(remainingNumber)
                    
                    let reserveTable: UILabel = UILabel(frame: CGRect(x: self.frame.width - 100 * scale, y: 35 * scale, width: 75 * scale, height: 20 * scale))
                    reserveTable.text = NSString(format: "您是%@", foodEntity.reserveTable) as String
                    reserveTable.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    reserveTable.textAlignment = NSTextAlignment.left
                    reserveTable.font = UIFont.systemFont(ofSize: 17 * scale)
                    foodView.addSubview(reserveTable)
                    
                    let reserveNumber: UILabel = UILabel(frame: CGRect(x: self.frame.width - 100 * scale, y: 65 * scale, width: 75 * scale, height: 20 * scale))
                    reserveNumber.text = foodEntity.reserveNumber
                    reserveNumber.textColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1)
                    reserveNumber.textAlignment = NSTextAlignment.right
                    reserveNumber.font = UIFont.systemFont(ofSize: 20 * scale)
                    foodView.addSubview(reserveNumber)
                case 2:
                    let missLabel: UILabel = UILabel(frame: CGRect(x: 180 * scale, y: 35 * scale, width: 75 * scale, height: 40 * scale))
                    missLabel.text = "已过号"
                    missLabel.textColor = UIColor.gray
                    missLabel.textAlignment = NSTextAlignment.center
                    missLabel.font = UIFont.systemFont(ofSize: 20 * scale)
                    foodView.addSubview(missLabel)
                    
                    let reserveLabel: UILabel = UILabel(frame: CGRect(x: foodView.frame.width - 95 * scale, y: 40 * scale, width: 80 * scale, height: 40 * scale))
                    reserveLabel.layer.cornerRadius = reserveLabel.frame.height / 2
                    reserveLabel.layer.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1).cgColor
                    reserveLabel.text = "取号"
                    reserveLabel.textColor = UIColor.white
                    reserveLabel.textAlignment = NSTextAlignment.center
                    reserveLabel.font = UIFont.boldSystemFont(ofSize: 20 * scale)
                    foodView.addSubview(reserveLabel)
                default:
                    let reserveLabel: UILabel = UILabel(frame: CGRect(x: foodView.frame.width - 95 * scale, y: 40 * scale, width: 80 * scale, height: 40 * scale))
                    reserveLabel.layer.cornerRadius = reserveLabel.frame.height / 2
                    reserveLabel.layer.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1).cgColor
                    reserveLabel.text = "取号"
                    reserveLabel.textColor = UIColor.white
                    reserveLabel.textAlignment = NSTextAlignment.center
                    reserveLabel.font = UIFont.boldSystemFont(ofSize: 20 * scale)
                    foodView.addSubview(reserveLabel)
                }
            } else {
                let openLabel: UILabel = UILabel(frame: CGRect(x: titleView.frame.width - 45 * scale, y: 2.5 * scale, width: 25 * scale, height: 25 * scale))
                openLabel.layer.cornerRadius = 2
                openLabel.layer.backgroundColor = UIColor(red: 164.0 / 255.0, green: 164.0 / 255.0, blue: 164.0 / 255.0, alpha: 1).cgColor
                openLabel.text = "休"
                openLabel.textColor = UIColor.white
                openLabel.textAlignment = NSTextAlignment.center
                openLabel.font = UIFont.systemFont(ofSize: 16 * scale)
                titleView.addSubview(openLabel)
                
                let reserveLabel: UILabel = UILabel(frame: CGRect(x: foodView.frame.width - 95 * scale, y: 40 * scale, width: 80 * scale, height: 40 * scale))
                reserveLabel.layer.cornerRadius = reserveLabel.frame.height / 2
                reserveLabel.layer.backgroundColor = UIColor(red: 255.0 / 255.0, green:  79.0 / 255.0, blue: 104.0 / 255.0, alpha: 1).cgColor
                reserveLabel.text = "取号"
                reserveLabel.textColor = UIColor.white
                reserveLabel.textAlignment = NSTextAlignment.center
                reserveLabel.font = UIFont.boldSystemFont(ofSize: 20 * scale)
                foodView.addSubview(reserveLabel)
            }
            
            let foodButton: UIButton = UIButton(frame: foodView.bounds)
            foodButton.tag = i;
            foodButton.addTarget(self, action: #selector(FoodView.tappedFoodButton(_:)), for: UIControlEvents.touchUpInside)
            foodView.addSubview(foodButton)
        }
        
        foodScrollView.contentSize = CGSize(width: foodScrollView.frame.width, height: CGFloat(foodListArray.count) * 125 * scale + 100 * scale < foodScrollView.frame.height ? foodScrollView.frame.height + 1 : CGFloat(foodListArray.count) * 125 * scale + 100 * scale)
    }
    
    func refresh() {
        delegate?.foodViewDidRefresh()
    }
    
    func refreshFoodList() {
        foodScrollView.headerEndRefreshing()
        rebuildFoodList()
    }
    
    func rebuildFoodList() {
//        foodScrollView.removeFromSuperview()
//        foodScrollView = UIScrollView(frame: CGRect(x: 0, y: titleHeight, width: frame.width, height: frame.height - titleHeight))
//        foodScrollView.showsVerticalScrollIndicator = false
//        self.addSubview(foodScrollView)
//        
//        foodScrollView.addHeaderWithTarget(self, action: "refresh")
//        
        for d in foodScrollView.subviews {
            if (!d.isMember(of: MJRefreshHeaderView.classForCoder())){d.removeFromSuperview()}
        }
        
        self.createFoodList()
    }
    
    func tappedFoodButton(_ button: UIButton) {
        let parameter: NSDictionary = NSDictionary(object: foodListArray.object(at: button.tag), forKey: "entity" as NSCopying)
        delegate?.foodViewDidTappedFoodButton(parameter)
    }
}
