//
//  ExchangeHistoryEntity.m
//  TSOutlets
//
//  Created by KDC on 15/11/25.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import "ExchangeHistoryEntity.h"

@implementation ExchangeHistoryEntity

@synthesize exchangeTime;
@synthesize exchangeType;
@synthesize listPicUrl;
@synthesize point;
@synthesize title;
@synthesize exchangeId;
@synthesize isDeal;
@synthesize qrCodeUrl;
@synthesize outDate;
@synthesize outType;

@synthesize exchangeEntity;

+ (ExchangeHistoryEntity *)member2ExchangeHistoryEntity: (NSManagedObject *)obj {
    ExchangeHistoryEntity *exchangeHistoryEntity = [[ExchangeHistoryEntity alloc] init];
    
    [exchangeHistoryEntity setExchangeType:[obj valueForKey:@"exchangeType"]];
    [exchangeHistoryEntity setTitle:[obj valueForKey:@"title"]];
    [exchangeHistoryEntity setExchangeTime:[obj valueForKey:@"exchangeTime"]];
    [exchangeHistoryEntity setOutDate:[obj valueForKey:@"outDate"]];
    [exchangeHistoryEntity setOutType:[obj valueForKey:@"outType"]];
    [exchangeHistoryEntity setListPicUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[obj valueForKey:@"listPicUrl"]]];
    [exchangeHistoryEntity setPoint:[obj valueForKey:@"point"]];
    [exchangeHistoryEntity setExchangeId:[obj valueForKey:@"exchangeId"]];
    [exchangeHistoryEntity setIsDeal:[obj valueForKey:@"isDeal"]];
    [exchangeHistoryEntity setQrCodeUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[obj valueForKey:@"qrCodeUrl"]]];
    
    
    return exchangeHistoryEntity;
}

@end
