//
//  MemberCoreDataHelper.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/6/8.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MemberCoreDataHelper.h"
#import "AppDelegate.h"
#import "sys/utsname.h"

@implementation MemberCoreDataHelper

+ (MemberEntity *)getMemberEntity {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    
    MemberEntity *memberEntity = [MemberEntity getDefaultMemberEntity];
    
    if (objects == nil || [objects count] == 0) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        [entity setValue:memberEntity.name forKey:@"name"];
        if ([[entity valueForKey:@"nickName"] isEqualToString:@"<null>"]) {
            memberEntity.nickName = @"";
        } else
        {
            [entity setValue:memberEntity.nickName forKey:@"nickName"];
        }
        if ([[entity valueForKey:@"gender"] isEqualToString:@"<null>"]) {
            memberEntity.gender = @"";
        } else
        {
            [entity setValue:memberEntity.gender forKey:@"gender"];
        }
        [entity setValue:memberEntity.phone forKey:@"phone"];
        //        [entity setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        
    } else {
        NSManagedObject *obj = [objects firstObject];
        
        if ([[obj valueForKey:@"nickName"] isEqualToString:@"<null>"]) {
            
            memberEntity.nickName = @"";
        } else
        {
            memberEntity.nickName = [obj valueForKey:@"nickName"];
        }
        if ([[obj valueForKey:@"gender"] isEqualToString:@"<null>"]) {
            
            memberEntity.gender = @"";
        } else
        {
            memberEntity.gender = [obj valueForKey:@"gender"];
        }
        memberEntity.name = [obj valueForKey:@"name"];
        memberEntity.token = [obj valueForKey:@"token"];
        memberEntity.phone = [obj valueForKey:@"phone"];
        memberEntity.portrait = [obj valueForKey:@"portrait"];
        memberEntity.image = [obj valueForKey:@"image"];
        memberEntity.login = (BOOL)[obj valueForKey:@"Login"];
        if ([[obj valueForKey:@"Bind"] isEqualToString:@"1"]) {
            memberEntity.Bind = YES;
        } else if ([[obj valueForKey:@"Bind"] isEqualToString:@"0"]) {
            memberEntity.Bind = NO;
        }
        
        memberEntity.memberID = [obj valueForKey:@"memberID"];
        
        //online Point
        memberEntity.onlineNumber     = [obj valueForKey:@"onlineNumber"];
        memberEntity.onlinePoint      = [obj valueForKey:@"onlinePoint"];
        memberEntity.onlineLevel      = [obj valueForKey:@"onlineLevel"];
        memberEntity.onlineTotalPoint = [obj valueForKey:@"onlineTotalPoint"];
        memberEntity.signinDay        = [obj valueForKey:@"signinDay"];
        memberEntity.onlineNextLevel  = [obj valueForKey:@"onlineNextLevel"];
        memberEntity.onlineNextPoint  = [obj valueForKey:@"onlineNextPoint"];
        memberEntity.onlinePrivilege  = [obj valueForKey:@"onlinePrivilege"];
        memberEntity.onlineHistory    = [obj valueForKey:@"onlineHistory"];
        memberEntity.resCode          = [obj valueForKey:@"resCode"];
        
        //offline Point
        memberEntity.offlineNumber = [obj valueForKey:@"offlineNumber"];
        memberEntity.offlineName = [obj valueForKey:@"offlineName"];
        memberEntity.offlinePhone = [obj valueForKey:@"offlinePhone"];
        memberEntity.offlinePoint = [obj valueForKey:@"offlinePoint"];
        memberEntity.offlinePrivilege = [obj valueForKey:@"offlinePrivilege"];
        memberEntity.offlineTotalPoint = [obj valueForKey:@"offlineTotalPoint"];
        memberEntity.offlineHistory = [obj valueForKey:@"offlineHistory"];
        
        memberEntity.exchangePlace = [obj valueForKey:@"exchangePlace"];
        memberEntity.exchangeTelephone = [obj valueForKey:@"exchangeTelephone"];
        
        //addresss
        memberEntity.province = [obj valueForKey:@"province"];
        memberEntity.city = [obj valueForKey:@"city"];
        memberEntity.area = [obj valueForKey:@"area"];
        memberEntity.address = [obj valueForKey:@"address"];
        memberEntity.zipcode = [obj valueForKey:@"zipcode"];
        memberEntity.receiver = [obj valueForKey:@"receiver"];
        
    }
    
    if (![context save:&error]) {
    }
    
    return memberEntity;
}

+ (HistoryEntity *)getHistoryEntity {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    HistoryEntity *historyEntity = [[HistoryEntity alloc] init];
    NSManagedObject *obj = [objects firstObject];
    
    historyEntity.name = [obj valueForKey:@"name"];
    historyEntity.point = [obj valueForKey:@"point"];
    historyEntity.date = [obj valueForKey:@"date"];
    historyEntity.type = [obj valueForKey:@"type"];
    
    if (![context save:&error]) {
    }
    
    return historyEntity;
}

+ (BOOL)checkLoginStatus {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%lu",(unsigned long)objects.count);
    
    if (objects == nil || [objects count] == 0) {
        return NO;
    } else {
        if ([[[objects firstObject] valueForKey:@"login"] isEqualToString:@"1"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)checkBindStatus {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%lu",(unsigned long)objects.count);
    
    if (objects == nil || [objects count] == 0) {
        return NO;
    } else {
        if ([[[objects firstObject] valueForKey:@"Bind"] isEqualToString:@"1"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)checkSync {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    
    if (objects == nil || [objects count] == 0) {
        return NO;
    } else {
        if ([[objects firstObject] valueForKey:@"sync"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)saveonlinePoints:(MemberEntity *)memberEntity{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    if (objects == nil || [objects count] == 0) {
        [entity setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [entity setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [entity setValue:memberEntity.signinDay forKey:@"signinDay"];
        [entity setValue:memberEntity.gamewheelBonus forKey:@"gamewheelBonus"];
    }  else {
        NSManagedObject *obj = [objects firstObject];
        [obj setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [obj setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [obj setValue:memberEntity.signinDay forKey:@"signinDay"];
        [obj setValue:memberEntity.gamewheelBonus forKey:@"gamewheelBonus"];
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveofflinePoints:(MemberEntity *)memberEntity{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    if (objects == nil || [objects count] == 0) {
        [entity setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [entity setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [entity setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [entity setValue:memberEntity.exchangePlace forKey:@"exchangePlace"];
        [entity setValue:memberEntity.exchangeTelephone forKey:@"exchangeTelephone"];
        if (memberEntity.Bind) {
            [entity setValue:@"1" forKey:@"isBind"];
        } else {
            [entity setValue:@"0" forKey:@"isBind"];
        }
    }  else {
        NSManagedObject *obj = [objects firstObject];
        [obj setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [obj setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [obj setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [obj setValue:memberEntity.exchangePlace forKey:@"exchangePlace"];
        [obj setValue:memberEntity.exchangeTelephone forKey:@"exchangeTelephone"];
        if (memberEntity.Bind) {
            [obj setValue:@"1" forKey:@"isBind"];
        } else {
            [obj setValue:@"0" forKey:@"isBind"];
        }
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveScoreHistorywithDictionary:(NSDictionary *)resDic{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    
    NSArray *historyArray = resDic[@"history"];
    
    for (NSDictionary *dic in historyArray) {
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        
        [entity setValue:[dic[@"Behavior"] valueForKey:@"Name"] forKey:@"scorehistoryName"];
        [entity setValue:[dic jk_stringForKey:@"OccurrenceTime"] forKey:@"scorehistoryDate"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"PointValue"]]   forKey:@"scorehistoryPoint"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic[@"Behavior"] valueForKey:@"BehaviorType"]] forKey: @"scorehistoryType"];
    }
    
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveHistorywithDictionary:(NSDictionary *)resDic {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        [context deleteObject:obj];
    }
    
    NSArray *historyArray = resDic[@"history"];
    
    for (NSDictionary *dic in historyArray) {
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:context];
        
        [entity setValue:[dic[@"Behavior"] valueForKey:@"Name"] forKey:@"name"];
        [entity setValue:[dic jk_stringForKey:@"OccurrenceTime"] forKey:@"date"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"PointValue"]]   forKey:@"point"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic[@"Behavior"] valueForKey:@"BehaviorType"]] forKey: @"type"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"Id"]] forKey:@"historyid"];
    }
    
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveExchangeListwithDictionary:(NSDictionary *)resDic {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExchangeList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        [context deleteObject:obj];
    }
    
    
        for (NSDictionary *dic in resDic) {
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ExchangeList" inManagedObjectContext:context];
        
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"EndTime"]] forKey:@"endTime"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"Stok"]] forKey:@"amount"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"OnLinePoint"]]   forKey:@"needOnlinePoint"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"OffLinePoint"]]   forKey:@"needOfflinePoint"];
        [entity setValue:[dic jk_stringForKey:@"Content"] forKey:@"content"];
        [entity setValue:[dic jk_stringForKey:@"Title"] forKey:@"title"];
        [entity setValue:[dic jk_stringForKey:@"Picture"] forKey:@"listPicUrl"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"Id"]] forKey:@"exchangeId"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"Visable"]] forKey:@"display"];
        
        NSMutableArray *carousel = [[NSMutableArray alloc] init];
        for (NSDictionary *dic2 in [dic jk_stringForKey:@"Files"]) {
            [carousel addObject:[NSString stringWithFormat:@"%@%@", APIAddr, [[dic2 valueForKey:@"File"] valueForKey:@"FileAddr"]]];
        }
        
        //NSLog(@"carousel : %@",carousel);
        [entity setValue:carousel forKey:@"carouselArray"];
        
        
    }
    
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveExchangeHistorywithDictionary:(NSDictionary *)resDic {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExchangeHistory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        [context deleteObject:obj];
    }
    
    for (NSDictionary *dic in resDic) {
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ExchangeHistory" inManagedObjectContext:context];
        
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"PayType"]] forKey:@"exchangeType"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"PayAmount"]] forKey:@"point"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"PayDate"]] forKey:@"exchangeTime"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"IsDeal"]] forKey:@"isDeal"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"QRCodeURL"]] forKey:@"qrCodeUrl"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"OutDate"]] forKey:@"outDate"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"OutType"]] forKey:@"OutType"];
        
        [entity setValue:[NSString stringWithFormat:@"%@",[[dic jk_stringForKey:@"Commodity"] valueForKey:@"Id"]] forKey:@"exchangeId"];
        [entity setValue:[[dic jk_stringForKey:@"Commodity"] valueForKey:@"Title"] forKey:@"title"];
        [entity setValue:[[dic jk_stringForKey:@"Commodity"] valueForKey:@"Picture"] forKey:@"listPicUrl"];
        
    }
    
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)saveofflineHistorywithDictionary:(NSDictionary *)resDic {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OfflineHistory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        [context deleteObject:obj];
    }
    NSString *str = [NSString stringWithFormat:@"%@", resDic[@"data"][@"ReturnOfQueryTradeInf"][@"ArrayOfQueryTradeResult"]];
    if (![str isEqualToString:@"<null>"] ) {
    NSDictionary *offlineDic = resDic[@"data"][@"ReturnOfQueryTradeInf"][@"ArrayOfQueryTradeResult"][@"Result"];
        
    for (NSDictionary *dic in offlineDic) {
        NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:@"OfflineHistory" inManagedObjectContext:context];
        
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"StoreName"]] forKey:@"tradePlace"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"TradeAmount"]] forKey:@"tradePrice"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"TradeDot"]] forKey:@"tradePoint"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"TradeNo"]] forKey:@"tradeNumber"];
        [entity setValue:[NSString stringWithFormat:@"%@",[dic jk_stringForKey:@"TradeTimeF"]] forKey:@"tradeTime"];
        
    }
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}


+ (NSArray *)getHistoryArray{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate mainObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *scorehistoryArray = [NSMutableArray array];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        HistoryEntity  *historyEntity = [HistoryEntity member2HistoryEntity:obj];
        
        [scorehistoryArray addObject:historyEntity];
    }
    //NSLog(@"%@",scorehistoryArray);
    return scorehistoryArray;
}

+ (NSArray *)getExchangeListArray{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate mainObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExchangeList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *exchangeListArray = [NSMutableArray array];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        ExchangeEntity  *exchangeEntity = [ExchangeEntity member2ExchangeEntity:obj];
        
        [exchangeListArray addObject:exchangeEntity];
    }
    //NSLog(@"%@",scorehistoryArray);
    return exchangeListArray;
}

+ (NSArray *)getExchangeHistory{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate mainObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ExchangeHistory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *exchangeHistoryListArray = [NSMutableArray array];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        ExchangeHistoryEntity  *exchangeHistoryEntity = [ExchangeHistoryEntity member2ExchangeHistoryEntity:obj];
        
        NSFetchRequest *exchangeFetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *exchangeEntity = [NSEntityDescription entityForName:@"ExchangeList" inManagedObjectContext:context];
        NSPredicate *shopPredicate = [NSPredicate predicateWithFormat:@"exchangeId = %@", exchangeHistoryEntity.exchangeId];
        [exchangeFetch setEntity:exchangeEntity];
        [exchangeFetch setPredicate:shopPredicate];
        
        NSArray *exchanges = [context executeFetchRequest:exchangeFetch error:&error];
        
        if (exchanges.count > 0) {
            NSManagedObject *exchange = [exchanges firstObject];
            exchangeHistoryEntity.exchangeEntity = [ExchangeEntity member2ExchangeEntity:exchange];
        }
        
        [exchangeHistoryListArray addObject:exchangeHistoryEntity];
    }
    return exchangeHistoryListArray;
}

+ (NSArray *)getOfflineHistory{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate mainObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OfflineHistory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *offlineHistoryListArray = [NSMutableArray array];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in objects) {
        OfflineHistoryEntity *offlineHistoryEntity = [OfflineHistoryEntity member2OfflineHistroyEntity:obj];
        
        [offlineHistoryListArray addObject:offlineHistoryEntity];
    }
    
    return offlineHistoryListArray;
    
}

+ (BOOL)loginMemberAndSaveMember:(MemberEntity *)memberEntity {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    
    if (objects == nil || [objects count] == 0) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        
        [entity setValue:memberEntity.name forKey:@"name"];
        [entity setValue:memberEntity.token forKey:@"token"];
        [entity setValue:memberEntity.phone forKey:@"phone"];
        [entity setValue:memberEntity.portrait forKey:@"portrait"];
        [entity setValue:memberEntity.image forKey:@"image"];
        [entity setValue:@"1" forKey:@"isLogin"];
        [entity setValue:memberEntity.memberID forKey:@"memberID"];
        [entity setValue:memberEntity.nickName forKey:@"nickName"];
        [entity setValue:memberEntity.gender forKey:@"gender"];
        
        //online Point
        [entity setValue:memberEntity.onlineNumber forKey:@"onlineNumber"];
        [entity setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [entity setValue:memberEntity.onlineLevel forKey:@"onlineLevel"];
        [entity setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [entity setValue:memberEntity.onlineNextLevel forKey:@"onlineNextLevel"];
        [entity setValue:memberEntity.onlineNextPoint forKey:@"onlineNextPoint"];
        [entity setValue:memberEntity.onlinePrivilege forKey:@"onlinePrivilege"];
        [entity setValue:memberEntity.onlineHistory forKey:@"onlineHistory"];
        
        //offline Point
        [entity setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [entity setValue:memberEntity.offlineName forKey:@"offlineName"];
        [entity setValue:memberEntity.offlinePhone forKey:@"offlinePhone"];
        [entity setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [entity setValue:memberEntity.offlinePrivilege forKey:@"offlinePrivilege"];
        [entity setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [entity setValue:memberEntity.offlineHistory forKey:@"offlineHistory"];
        
        //address
        
        [entity setValue:memberEntity.province forKey:@"province"];
        [entity setValue:memberEntity.city forKey:@"city"];
        [entity setValue:memberEntity.area forKey:@"area"];
        [entity setValue:memberEntity.address forKey:@"address"];
        [entity setValue:memberEntity.zipcode forKey:@"zipcode"];
        [entity setValue:memberEntity.receiver forKey:@"receiver"];
        
        [entity setValue:@"1" forKey:@"sync"];
    } else {
        NSManagedObject *obj = [objects firstObject];
        
        [obj setValue:memberEntity.name forKey:@"name"];
        [obj setValue:memberEntity.token forKey:@"token"];
        [obj setValue:memberEntity.phone forKey:@"phone"];
        [obj setValue:memberEntity.portrait forKey:@"portrait"];
        [obj setValue:memberEntity.image forKey:@"image"];
        [obj setValue:@"1" forKey:@"isLogin"];
        [obj setValue:memberEntity.memberID forKey:@"memberID"];
        [obj setValue:memberEntity.nickName forKey:@"nickName"];
        [obj setValue:memberEntity.gender forKey:@"gender"];
        
        //online Point
        [obj setValue:memberEntity.onlineNumber forKey:@"onlineNumber"];
        [obj setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [obj setValue:memberEntity.onlineLevel forKey:@"onlineLevel"];
        [obj setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [obj setValue:memberEntity.onlineNextLevel forKey:@"onlineNextLevel"];
        [obj setValue:memberEntity.onlineNextPoint forKey:@"onlineNextPoint"];
        [obj setValue:memberEntity.onlinePrivilege forKey:@"onlinePrivilege"];
        [obj setValue:memberEntity.onlineHistory forKey:@"onlineHistory"];
        
        //offline Point
        [obj setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [obj setValue:memberEntity.offlineName forKey:@"offlineName"];
        [obj setValue:memberEntity.offlinePhone forKey:@"offlinePhone"];
        [obj setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [obj setValue:memberEntity.offlinePrivilege forKey:@"offlinePrivilege"];
        [obj setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [obj setValue:memberEntity.offlineHistory forKey:@"offlineHistory"];
        
        //address
        
        [obj setValue:memberEntity.province forKey:@"province"];
        [obj setValue:memberEntity.city forKey:@"city"];
        [obj setValue:memberEntity.area forKey:@"area"];
        [obj setValue:memberEntity.address forKey:@"address"];
        [obj setValue:memberEntity.zipcode forKey:@"zipcode"];
        [obj setValue:memberEntity.receiver forKey:@"receiver"];
        
        [obj setValue:@"1" forKey:@"sync"];
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)updateMemberInfo:(MemberEntity *)memberEntity {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    
    if (objects == nil || [objects count] == 0) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        
        [entity setValue:memberEntity.name forKey:@"name"];
        [entity setValue:memberEntity.token forKey:@"token"];
        [entity setValue:memberEntity.phone forKey:@"phone"];
        [entity setValue:memberEntity.portrait forKey:@"portrait"];
        [entity setValue:memberEntity.image forKey:@"image"];
        memberEntity.login ? [entity setValue:@"1" forKey:@"isLogin"] : [entity setValue:nil forKey:@"isLogin"];
        [entity setValue:memberEntity.memberID forKey:@"memberID"];
        [entity setValue:memberEntity.nickName forKey:@"nickName"];
        [entity setValue:memberEntity.gender forKey:@"gender"];
        
        //online Point
        [entity setValue:memberEntity.onlineNumber forKey:@"onlineNumber"];
        [entity setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [entity setValue:memberEntity.onlineLevel forKey:@"onlineLevel"];
        [entity setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [entity setValue:memberEntity.onlineNextLevel forKey:@"onlineNextLevel"];
        [entity setValue:memberEntity.onlineNextPoint forKey:@"onlineNextPoint"];
        [entity setValue:memberEntity.onlinePrivilege forKey:@"onlinePrivilege"];
        [entity setValue:memberEntity.onlineHistory forKey:@"onlineHistory"];
        
        //offline Point
        [entity setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [entity setValue:memberEntity.offlineName forKey:@"offlineName"];
        [entity setValue:memberEntity.offlinePhone forKey:@"offlinePhone"];
        [entity setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [entity setValue:memberEntity.offlinePrivilege forKey:@"offlinePrivilege"];
        [entity setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [entity setValue:memberEntity.offlineHistory forKey:@"offlineHistory"];
        
        //address
        
        [entity setValue:memberEntity.province forKey:@"province"];
        [entity setValue:memberEntity.city forKey:@"city"];
        [entity setValue:memberEntity.area forKey:@"area"];
        [entity setValue:memberEntity.address forKey:@"address"];
        [entity setValue:memberEntity.zipcode forKey:@"zipcode"];
        [entity setValue:memberEntity.receiver forKey:@"receiver"];
        
        [entity setValue:nil forKey:@"sync"];
    } else {
        NSManagedObject *obj = [objects firstObject];
        
        [obj setValue:memberEntity.name forKey:@"name"];
        [obj setValue:memberEntity.token forKey:@"token"];
        [obj setValue:memberEntity.phone forKey:@"phone"];
        [obj setValue:memberEntity.portrait forKey:@"portrait"];
        [obj setValue:memberEntity.image forKey:@"image"];
        memberEntity.login ? [obj setValue:@"1" forKey:@"isLogin"] : [obj setValue:nil forKey:@"isLogin"];
        [obj setValue:memberEntity.memberID forKey:@"memberID"];
        [obj setValue:memberEntity.nickName forKey:@"nickName"];
        [obj setValue:memberEntity.gender forKey:@"gender"];
        
        //online Point
        [obj setValue:memberEntity.onlineNumber forKey:@"onlineNumber"];
        [obj setValue:memberEntity.onlinePoint forKey:@"onlinePoint"];
        [obj setValue:memberEntity.onlineLevel forKey:@"onlineLevel"];
        [obj setValue:memberEntity.onlineTotalPoint forKey:@"onlineTotalPoint"];
        [obj setValue:memberEntity.onlineNextLevel forKey:@"onlineNextLevel"];
        [obj setValue:memberEntity.onlineNextPoint forKey:@"onlineNextPoint"];
        [obj setValue:memberEntity.onlinePrivilege forKey:@"onlinePrivilege"];
        [obj setValue:memberEntity.onlineHistory forKey:@"onlineHistory"];
        
        //offline Point
        [obj setValue:memberEntity.offlineNumber forKey:@"offlineNumber"];
        [obj setValue:memberEntity.offlineName forKey:@"offlineName"];
        [obj setValue:memberEntity.offlinePhone forKey:@"offlinePhone"];
        [obj setValue:memberEntity.offlinePoint forKey:@"offlinePoint"];
        [obj setValue:memberEntity.offlinePrivilege forKey:@"offlinePrivilege"];
        [obj setValue:memberEntity.offlineTotalPoint forKey:@"offlineTotalPoint"];
        [obj setValue:memberEntity.offlineHistory forKey:@"offlineHistory"];
        
        //address
        
        [obj setValue:memberEntity.province forKey:@"province"];
        [obj setValue:memberEntity.city forKey:@"city"];
        [obj setValue:memberEntity.area forKey:@"area"];
        [obj setValue:memberEntity.address forKey:@"address"];
        [obj setValue:memberEntity.zipcode forKey:@"zipcode"];
        [obj setValue:memberEntity.receiver forKey:@"receiver"];
        
        [obj setValue:nil forKey:@"sync"];
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)syncMemberInfo {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"%d",objects.count);
    
    if (objects == nil || [objects count] == 0) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
        
        [entity setValue:@"1" forKey:@"sync"];
    } else {
        NSManagedObject *obj = [objects firstObject];
        
        [obj setValue:@"1" forKey:@"sync"];
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)logoutMember {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (objects == nil || [objects count] == 0) {
        return YES;
    } else {
        NSManagedObject *obj = [objects firstObject];
        
        [obj setValue:nil forKey:@"isLogin"];
    }
    
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)getMemberToken {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (objects == nil || [objects count] == 0) {
        return @"";
    } else {
        NSManagedObject *obj = [objects firstObject];
        return [obj valueForKey:@"token"];
    }
    
    return @"";
}
// rescode = 0 表示可以当天没有签到
+ (NSString *)getresCode {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (objects == nil || [objects count] == 0) {
        return @"";
    } else {
        NSManagedObject *obj = [objects firstObject];
        return [obj valueForKey:@"resCode"];
    }
    
    return @"";
}

+ (NSString *)getDeviceInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) platform = @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) platform = @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) platform = @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) platform = @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) platform = @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) platform = @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) platform = @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) platform = @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) platform = @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) platform = @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) platform = @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) platform = @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) platform = @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) platform = @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) platform = @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   platform = @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   platform = @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   platform = @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   platform = @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   platform = @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   platform = @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   platform = @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   platform = @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   platform = @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   platform = @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   platform = @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   platform = @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   platform = @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   platform = @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   platform = @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   platform = @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   platform = @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   platform = @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   platform = @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   platform = @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   platform = @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   platform = @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   platform = @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   platform = @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   platform = @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      platform = @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    platform = @"iPhone Simulator";
    
    return [NSString stringWithFormat:@"%@ %@ %@",platform ,[[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
}

@end
