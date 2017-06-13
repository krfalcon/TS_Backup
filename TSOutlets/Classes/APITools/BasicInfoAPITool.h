//
//  BasicInfoAPITool.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/3/26.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BasicInfoAPIToolDelegate;

@interface BasicInfoAPITool : NSObject<NSURLConnectionDelegate,NSURLSessionDelegate>
{
    NSMutableData* getBasicInfoData;
    NSMutableData* getBasicInfoZipData;
    NSMutableData* updateBasicInfoData;
    NSMutableData* checkVersionData;
    
    NSURLSession* getBasicInfoSession;
    NSURLSession* getBasicInfoZipSession;
    NSURLSession* updateBasicInfoSession;
    NSURLSession* checkVersionSession;
    
    NSURLConnection* getBasicInfoConnection;
    NSURLConnection* getBasicInfoZipConnection;
    NSURLConnection* updateBasicInfoConnection;
    NSURLConnection* checkVersionConnection;
}

@property (weak, nonatomic) id<BasicInfoAPIToolDelegate> delegate;

#pragma mark - network
- (void)getBasicInfoWithDeviceInfo:(NSString *)deviceInfo;
- (void)updateBasicInfoByDate:(NSString *)dateTime;

#pragma mark - local
- (void)checkVersionOfApp;

@end


@protocol BasicInfoAPIToolDelegate <NSObject>

- (void)didGetBasicInfo;
- (void)didUpdateBasicInfo;

@end
