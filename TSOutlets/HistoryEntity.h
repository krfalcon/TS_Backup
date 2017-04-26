//
//  HistoryEntity.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/29/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HistoryEntity : NSObject

@property (strong, nonatomic) NSString*  date;
@property (strong, nonatomic) NSString*  point;
@property (strong, nonatomic) NSString*  name;
@property (strong, nonatomic) NSString*  type;
@property (strong, nonatomic) NSString*  historyid;

+ (HistoryEntity *)member2HistoryEntity: (NSManagedObject *) obj;

@end
