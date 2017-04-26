//
//  ArticleCoreDataHelper.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/3/26.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventEntity.h"
#import "VideoEntity.h"
#import "IndexEntity.h"
#import "ServiceEntity.h"
#import "NSDictionary+JKSafeAccess.h"


@interface ArticleCoreDataHelper : NSObject

+ (BOOL)addBasicInfoWithInfoArray:(NSDictionary *)jsonDic;
+ (BOOL)updateBasicInfoWithInfoArray:(NSDictionary *)jsonDic;

+ (IndexEntity *)getIndexList;

#pragma mark - Shop View

+ (NSArray *)getShopList;
+ (NSArray *)getFavoriteShopList;
+ (NSArray *)getItemArrayWithShopID:(NSString *)shopID;
+ (NSArray *)getEventArrayWithShopID:(NSString *)shopID;
+ (NSArray *)getVideoArrayWithShopID:(NSString *)shopID;
+ (ShopEntity *)getShopEntityByID:(NSString *)shopID;
+ (NSString *)getF1MapUrl;
+ (NSString *)getF2MapUrl;
+ (NSString *)getExchangeTelephone;
+ (NSString *)getExchangePlace;

#pragma mark - Event View

+ (NSArray *)getEventList;
+ (NSArray *)getEventShopList;
+ (NSArray *)getSaleList;
+ (NSArray *)getEventMallList;
+ (EventEntity *)getEventEntityByID:(NSString *)eventID;

#pragma mark - Video View

+ (NSArray *)getVideoShopList;
+ (NSArray *)getVideoMallList;

#pragma mark - Item View

+ (NSArray *)getItemList;

#pragma mark - Service View

+ (ServiceEntity *)getServiceEntity;
+ (NSString *)getServiceTraffic;
+ (NSString *)getServiceInfo;
+ (NSString *)getServiceQA;

#pragma mark - Wifi View

+ (NSString *)getWifiInfo;

#pragma mark - Food View

+ (NSArray *)getFoodList;

@end
