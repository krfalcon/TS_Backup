//
//  FoodViewController.swift
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

import UIKit

class FoodViewController: MotherViewController, FoodViewDelegate {
    var foodView: FoodView!
    
    override func initFirstView(withParameter parameter: [AnyHashable: Any]!) {
        foodView = FoodView(frame: view.bounds);
        foodView.delegate = self;
        view.addSubview(foodView);
        self.foodView.showLoadingView()
        
        let operation: BlockOperation = BlockOperation(block: {
            self.foodView.foodListArray = ArticleCoreDataHelper.getFoodList() as NSArray!
        })
        
        operation.completionBlock = {OperationQueue.main.addOperation({
            self.foodView.createFoodList()
            self.foodView.hideLoadingView()
        })}
        
        addOperationToCoredateOperation(with: operation)
        
        currentView = foodView
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "shouldRecordLog"), object: "Reserve List")
        
        //        let mat: FoodAPITool = FoodAPITool()
        //        mat.getQueueList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodViewController.getReserveList(_:)), name: NSNotification.Name(rawValue: "getReserveList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FoodViewController.getReserveListFailed), name: NSNotification.Name(rawValue: "getReserveListFailed"), object: nil)
    }
    
    // MARK: - Food View Delegate
    
    func foodViewDidTappedFoodButton(_ parameter: NSDictionary) {
        self .pushViewController(with: ViewControllerType.typeFoodReserve, andParameter: [AnyHashable: Any]())
    }
    
    func foodViewDidRefresh() {
        let mat: FoodAPITool = FoodAPITool()
        mat.getQueueList()
    }
    
    // MARK: - Notification
    
    func getReserveList(_ noti: Notification) {
        self.foodView.foodListArray = (noti.object as! NSArray)
        self.foodView.refreshFoodList()
    }
    
    func getReserveListFailed() {
        self.foodView.refreshFoodList()
    }
}
