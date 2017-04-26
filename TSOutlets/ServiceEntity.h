//
//  ServiceEntity.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/13/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JSONHelper.h"
#import "WsAddrHelper.h"

@interface ServiceEntity : NSObject

@property (strong, nonatomic) NSString *faqUrl;
@property (strong, nonatomic) NSString *introUrl;
@property (strong, nonatomic) NSString *trafficUrl;

+ (ServiceEntity *)article2ServiceEntity:(NSManagedObject *)QAUrl;
@end
