//
//  OnlineDetailViewController.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/12.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MotherViewController.h"

#import "OnlinePointDetailView.h"
#import "MemberAPITool.h"

@interface OnlineDetailViewController : MotherViewController
{
    OnlinePointDetailView*                                  onlinePointDetailView;
    
    MemberAPITool*                                          memberAPI;
    
}

@property(strong, nonatomic) MemberEntity*                  memberEntity;


@end
