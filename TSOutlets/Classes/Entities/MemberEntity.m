//
//  MemberEntity.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/19.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MemberEntity.h"

@implementation MemberEntity

@synthesize memberID;
@synthesize name;
@synthesize nickName;
@synthesize gender;
@synthesize phone;
@synthesize image;
@synthesize token;
@synthesize portrait;
@synthesize login;
@synthesize Bind;


#pragma mark - online part

@synthesize province;
@synthesize city;
@synthesize area;
@synthesize address;
@synthesize zipcode;
@synthesize receiver;

#pragma mark - online part

@synthesize onlineNumber;
@synthesize onlinePoint;
@synthesize onlineLevel;
@synthesize onlineTotalPoint;
@synthesize onlineNextPoint;
@synthesize onlineNextLevel;
@synthesize onlinePrivilege;
@synthesize onlineHistory;
@synthesize signinDay;
@synthesize resCode;
@synthesize scorehistoryDate;
@synthesize scorehistoryPoint;
@synthesize scorehistoryName;
@synthesize scorehistoryType;
@synthesize gamewheelBonus;

#pragma mark - offline part

@synthesize offlineNumber;
@synthesize offlineName;
@synthesize offlinePhone;
@synthesize offlinePoint;
@synthesize offlineTotalPoint;
@synthesize offlinePrivilege;
@synthesize offlineHistory;

@synthesize exchangePlace;
@synthesize exchangeTelephone;

+ (MemberEntity *)getDefaultMemberEntity {
    MemberEntity *memberEntity = [[MemberEntity alloc] init];
    
    memberEntity.name             = @"";
    memberEntity.nickName         = @"昵称";
    memberEntity.phone            = @"00000000000";
    memberEntity.gender           = @"男";
    
    memberEntity.onlineNumber     = @"No.0";
    memberEntity.onlinePoint      = @"30";
    memberEntity.onlineTotalPoint = @"30";
    memberEntity.signinDay        = @"-1";
    
    memberEntity.offlineNumber    = @"未绑定";
    memberEntity.offlinePoint     = @"0";
    memberEntity.offlineTotalPoint= @"0";
    
    memberEntity.province         = @"";
    memberEntity.city             = @"";
    memberEntity.area             = @"";
    memberEntity.address          = @"";
    memberEntity.zipcode          = @"";
    memberEntity.receiver         = @"";
    
    return memberEntity;
}

+ (MemberEntity *)member2MemberEntity: (NSManagedObject *) obj {
    MemberEntity *memberEntity = [[MemberEntity alloc] init];
    
    [memberEntity setScorehistoryDate:[obj valueForKey:@"scorehistoryDate"]];
    [memberEntity setScorehistoryName:[obj valueForKey:@"scorehistoryName"]];
    [memberEntity setScorehistoryPoint:[obj valueForKey:@"scorehistoryPoint"]];
    [memberEntity setScorehistoryType:[obj valueForKey:@"scorehistoryType"]];
    
    return memberEntity;
}

@end
