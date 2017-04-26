//
//  OfflineDetailViewController.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/12.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MotherViewController.h"

#import "OfflinePointDetailView.h"
#import "MemberAPITool.h"

@interface OfflineDetailViewController : MotherViewController
{
    NSArray*                                                rawOfflineHistoryArray;
    NSArray*                                                originOfflineHistoryArray;
    
    OfflinePointDetailView*                                 offlinePointDetailView;
    MemberAPITool*                                          memberAPI;
    
}

@property(strong, nonatomic) MemberEntity*                  memberEntity;

@end
