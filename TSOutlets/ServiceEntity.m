//
//  ServiceEntity.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/13/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "ServiceEntity.h"

@implementation ServiceEntity

@synthesize faqUrl;
@synthesize introUrl;
@synthesize trafficUrl;

+ (ServiceEntity *)article2ServiceEntity:(NSManagedObject *)QAUrl
{
    ServiceEntity *serviceEntity = [[ServiceEntity alloc] init];
    
    [serviceEntity setFaqUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[QAUrl valueForKey:@"faqurl"]]];
    [serviceEntity setIntroUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[QAUrl valueForKey:@"introurl"]]];
    [serviceEntity setTrafficUrl:[NSString stringWithFormat:@"%@%@",APIAddr,[QAUrl valueForKey:@"trafficurl"]]];
    
    return serviceEntity;
}

@end