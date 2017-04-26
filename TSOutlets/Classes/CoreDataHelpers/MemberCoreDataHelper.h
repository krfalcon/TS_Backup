//
//  MemberCoreDataHelper.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/6/8.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberEntity.h"
#import "HistoryEntity.h"
#import "ExchangeEntity.h"
#import "ExchangeHistoryEntity.h"
#import "OfflineHistoryEntity.h"
#import "NSDictionary+JKSafeAccess.h"


@interface MemberCoreDataHelper : NSObject

+ (MemberEntity *)getMemberEntity;
+ (HistoryEntity *)getHistoryEntity;

+ (BOOL)checkLoginStatus;
+ (BOOL)checkBindStatus;
+ (BOOL)checkSync;
+ (BOOL)saveonlinePoints:(MemberEntity *)memberEntity;
+ (BOOL)saveofflinePoints:(MemberEntity *)memberEntity;
//+ (BOOL)saveScoreHistorywithDictionary:(NSDictionary *)resDic;
+ (BOOL)loginMemberAndSaveMember:(MemberEntity *)memberEntity;
+ (BOOL)updateMemberInfo:(MemberEntity *)memberEntity;
+ (BOOL)syncMemberInfo;
+ (BOOL)logoutMember;

+ (NSString *)getMemberToken;
+ (NSString *)getresCode;
+ (NSString *)getDeviceInfo;
//+ (NSArray *)getScoreHistoryArray;

+ (BOOL)saveHistorywithDictionary:(NSDictionary *)resDic;
+ (BOOL)saveExchangeListwithDictionary:(NSDictionary *)resDic;
+ (BOOL)saveExchangeHistorywithDictionary:(NSDictionary *)resDic;
+ (BOOL)saveofflineHistorywithDictionary:(NSDictionary *)resDic;
+ (NSArray *)getHistoryArray;
+ (NSArray *)getExchangeListArray;
+ (NSArray *)getExchangeHistory;
+ (NSArray *)getOfflineHistory;

@end
