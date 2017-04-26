//
//  ExchangeHistoryEntity.h
//  TSOutlets
//
//  Created by KDC on 15/11/25.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WsAddrHelper.h"
#import "ExchangeEntity.h"

@interface ExchangeHistoryEntity : NSObject

@property (strong, nonatomic) NSString*  exchangeTime;
@property (strong, nonatomic) NSString*  exchangeType;
@property (strong, nonatomic) NSString*  listPicUrl;
@property (strong, nonatomic) NSString*  point;
@property (strong, nonatomic) NSString*  title;
@property (strong, nonatomic) NSString*  exchangeId;
@property (strong, nonatomic) NSString*  isDeal;
@property (strong, nonatomic) NSString*  qrCodeUrl;
@property (strong, nonatomic) NSString*  outDate;
@property (strong, nonatomic) NSString*  outType;


@property (strong, nonatomic) ExchangeEntity* exchangeEntity;

+ (ExchangeHistoryEntity *)member2ExchangeHistoryEntity: (NSManagedObject *)obj;

@end
