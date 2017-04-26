//
//  MemberAPITool.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/6/1.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberCoreDataHelper.h"
#import "ConfigCoreDataHelper.h"
#import "BrandCoreDataHelper.h"

@interface MemberAPITool : NSObject<NSURLConnectionDelegate>
{
    NSMutableData* loginData;
    NSMutableData* BindData;
    NSMutableData* confirmData;
    NSMutableData* uploadPortraitData;
    NSMutableData* uploadInfoData;
    NSMutableData* verificationData;
    NSMutableData* registerData;
    NSMutableData* resetData;
    NSMutableData* deviceData;
    
    NSMutableData* setFaveriteData;
    NSMutableData* getOnlinePointData;
    NSMutableData* getFaveriteData;
    
    NSMutableData* onlinePointsData;
    NSMutableData* signinData;
    NSMutableData* wheellotteryData;
    NSMutableData* onlineHistoryData;
    NSMutableData* offlinePointsData;
    NSMutableData* offlineHistoryData;
    NSMutableData* offlineBindData;
    
    NSMutableData* exchangeListData;
    NSMutableData* exchangeHistoryData;
    NSMutableData* exchangeData;
    NSMutableData* exchangeInfoData;
    
    NSURLConnection* loginConnection;
    NSURLConnection* BindConnection;
    NSURLConnection* confirmConnection;
    NSURLConnection* uploadPortraitConnection;
    NSURLConnection* uploadInfoConnection;
    NSURLConnection* verificationConnection;
    NSURLConnection* registerConnection;
    NSURLConnection* resetConnection;
    NSURLConnection* deviceConnection;
    NSURLConnection* wheellotteryConnection;
    
    NSURLConnection* setFaveriteConnection;
    NSURLConnection* getOnlinePointConnection;
    NSURLConnection* signinConnection;
    NSURLConnection* getFaveriteConnection;
    
    NSURLConnection* onlinePointsConnection;
    NSURLConnection* onlineHistoryConnection;
    NSURLConnection* offlinePointsConnection;
    NSURLConnection* offlineHistoryConnection;
    NSURLConnection* offlineBindConnection;
    
    NSURLConnection* exchangeListConnection;
    NSURLConnection* exchangeHistoryConnection;
    NSURLConnection* exchangeConnection;
    NSURLConnection* exchangeInfoConnection;
}
@property (strong,nonatomic) MemberEntity*      memberEntity;

#pragma mark - network
- (void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password;
- (void)confirmAuthentication;
- (void)uploadMemberPortrait:(NSData *)portrait;
- (void)uploadMemberInfo:(MemberEntity *)member;

- (void)getVerificationCodeWithPhone:(NSString *)phone;
- (void)registerMemberWithPhone:(NSString *)phone andPassword:(NSString *)password andVerificationCode:(NSString *)verification;
- (void)resetPasswordWithPhone:(NSString *)phone andPassword:(NSString *)password andVerificationCode:(NSString *)verification;
- (void)uploadDeviceInfo;

//favorite stuff
- (void)setFavoriteWithBrandID:(NSString *)brandID;
- (void)getFavorites;

//礼品兑换
- (void)getExchangeList;
- (void)getExchangeHistory;
- (void)getExchangePlaceAndTelephone;
- (void)exchangeInfoViewDidTapExchangeWithExchangeEntity:(ExchangeEntity *)exchangeEntity;

//points stuff
- (void)getOnlinePoints;
- (void)getOnlinePointsHistory;
- (void)getOfflinePoints;
- (void)getOfflinePointsHistory;
- (void)bindWithCardNumber:(NSString *)cardNumber andPassword:(NSString *)password;
- (void)setSigninDay;
- (void)setWheelLottery;

#pragma mark - local
- (BOOL)checkMemberSync;
- (MemberEntity *)getMemberEntity;
- (BOOL)updateMemberInfo:(MemberEntity *)memberEntity;
- (BOOL)updateMemberPortrait:(MemberEntity *)memberEntity;
- (BOOL)syncMemberInfo;
- (BOOL)getLoginStatus;
- (BOOL)getBindStatus;
- (BOOL)loginMemberAndSaveMember:(MemberEntity *)memberEntity;
- (BOOL)logoutMember;

//favorite stuff
- (NSString *)checkFavoriteSync;
- (BOOL)updateFavoriteBrandWithBrandIDs:(NSArray *)brandIDs;
- (ShopEntity *)setLocalFavoriteWithBrandID:(ShopEntity *)brand;
- (BOOL)syncFavorite;
- (BOOL)clearFavorite;

//congfig stuff
- (NSString *)getLastUpdateDate;
- (BOOL)checkAppGuideSign:(NSString *)guideSign;

- (NSString *)getMemberToken;
- (NSString *)getDeviceInfo;

@end
