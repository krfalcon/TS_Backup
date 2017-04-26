//
//  ExchangeEntity.h
//  TSOutlets
//
//  Created by KDC on 15/11/24.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WsAddrHelper.h"

@interface ExchangeEntity : NSObject

@property (strong, nonatomic) NSString*  amount;
@property (strong, nonatomic) NSString*  content;
@property (strong, nonatomic) NSString*  endTime;
@property (strong, nonatomic) NSString*  listPicUrl;
@property (strong, nonatomic) NSString*  needOnlinePoint;
@property (strong, nonatomic) NSString*  needOfflinePoint;
@property (strong, nonatomic) NSString*  title;
@property (strong, nonatomic) NSString*  exchangeId;
@property (strong, nonatomic) NSString*  display;
@property (strong, nonatomic) NSArray*   carouselArray;

+ (ExchangeEntity *)member2ExchangeEntity: (NSManagedObject *) obj;

@end
