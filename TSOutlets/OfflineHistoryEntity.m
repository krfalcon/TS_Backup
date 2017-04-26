//
//  OfflineHistoryEntity.m
//  TSOutlets
//
//  Created by KDC on 15/11/30.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import "OfflineHistoryEntity.h"

@implementation OfflineHistoryEntity

@synthesize tradeNumber;
@synthesize tradePlace;
@synthesize tradePoint;
@synthesize tradePrice;
@synthesize tradeTime;



+ (OfflineHistoryEntity *)member2OfflineHistroyEntity:(NSManagedObject *)obj {
    OfflineHistoryEntity *offlineHistoryEntity = [[OfflineHistoryEntity alloc] init];
    
    [offlineHistoryEntity setTradeNumber:[obj valueForKey:@"tradeNumber"]];
    [offlineHistoryEntity setTradePlace:[obj valueForKey:@"tradePlace"]];
    [offlineHistoryEntity setTradePoint:[obj valueForKey:@"tradePoint"]];
    [offlineHistoryEntity setTradePrice:[obj valueForKey:@"tradePrice"]];
    [offlineHistoryEntity setTradeTime:[obj valueForKey:@"tradeTime"]];
    
    return offlineHistoryEntity;
}

@end