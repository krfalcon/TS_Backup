//
//  ExchangeEntity.m
//  TSOutlets
//
//  Created by KDC on 15/11/24.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import "ExchangeEntity.h"

@implementation ExchangeEntity

@synthesize amount;
@synthesize content;
@synthesize endTime;
@synthesize listPicUrl;
@synthesize needOfflinePoint;
@synthesize needOnlinePoint;
@synthesize title;
@synthesize exchangeId;
@synthesize display;
@synthesize carouselArray;

+ (ExchangeEntity *)member2ExchangeEntity:(NSManagedObject *)obj {
    ExchangeEntity *exchangeEntity = [[ExchangeEntity alloc] init];
    
    [exchangeEntity setAmount:[obj valueForKey:@"amount"]];
    [exchangeEntity setContent:[obj valueForKey:@"content"]];
    [exchangeEntity setEndTime:[obj valueForKey:@"endTime"]];
    [exchangeEntity setListPicUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[obj valueForKey:@"listPicUrl"]]];
    [exchangeEntity setNeedOfflinePoint:[obj valueForKey:@"needOfflinePoint"]];
    [exchangeEntity setNeedOnlinePoint:[obj valueForKey:@"needOnlinePoint"]];
    [exchangeEntity setTitle:[obj valueForKey:@"title"]];
    [exchangeEntity setExchangeId:[obj valueForKey:@"exchangeId"]];
    [exchangeEntity setDisplay:[obj valueForKey:@"display"]];
    [exchangeEntity setCarouselArray:[obj valueForKey:@"carouselArray"]];
    
    return exchangeEntity;
}


@end
