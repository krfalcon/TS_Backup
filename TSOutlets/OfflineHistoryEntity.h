//
//  OfflineHistoryEntity.h
//  TSOutlets
//
//  Created by KDC on 15/11/30.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WsAddrHelper.h"

@interface OfflineHistoryEntity : NSObject

@property (strong, nonatomic) NSString*     tradeNumber;
@property (strong, nonatomic) NSString*     tradePlace;
@property (strong, nonatomic) NSString*     tradePoint;
@property (strong, nonatomic) NSString*     tradePrice;
@property (strong, nonatomic) NSString*     tradeTime;

+ (OfflineHistoryEntity *)member2OfflineHistroyEntity:(NSManagedObject *)obj;

@end
