//
//  HistoryEntity.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/29/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "HistoryEntity.h"

@implementation HistoryEntity

@synthesize date;
@synthesize point;
@synthesize name;
@synthesize type;
@synthesize historyid;

+ (HistoryEntity *)member2HistoryEntity: (NSManagedObject *) obj {
    HistoryEntity *historyEntity = [[HistoryEntity alloc] init];
    
    [historyEntity setDate:[obj valueForKey:@"date"]];
    [historyEntity setName:[obj valueForKey:@"name"]];
    [historyEntity setPoint:[obj valueForKey:@"point"]];
    [historyEntity setType:[obj valueForKey:@"type"]];
    [historyEntity setHistoryid:[obj valueForKey:@"historyid"]];
    
    return historyEntity;
}



@end
