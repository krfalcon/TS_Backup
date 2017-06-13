//
//  MemberAPITool.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/6/1.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MemberAPITool.h"
#import "JSONHelper.h"
#import "WsAddrHelper.h"
#import "SingleCase.h"
#import "HTTPPostDataGenerator.h"

@implementation MemberAPITool

#pragma mark - network
- (void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/Login?mobilePhone=%@&password=%@&mobileField=%@&clientId=%@", APIAddr, phone, password, [MemberCoreDataHelper getDeviceInfo], [SingleCase singleCase].clientID];
    if ([SingleCase singleCase].deviceToken) { wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&deviceToken=%@", [SingleCase singleCase].deviceToken]]; }
    
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    loginConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [loginConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)bindWithCardNumber:(NSString *)cardNumber andPassword:(NSString *)password {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/BindOffLineCard?token=%@&cardCode=%@&password=%@", APIAddr, [MemberCoreDataHelper getMemberToken],  cardNumber, password];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    BindConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [BindConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)confirmAuthentication {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/Authentication?token=%@", APIAddr, [MemberCoreDataHelper getMemberToken]];

    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    confirmConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [confirmConnection dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)uploadMemberPortrait:(NSData *)portrait {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/UploadPortraitTest", APIAddr];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    [post_dict setObject:[MemberCoreDataHelper getMemberToken] forKey:@"token"];
    [post_dict setObject:portrait forKey:@"filedata"];
    
    NSData *postData = [HTTPPostDataGenerator generateFormDataFromPostDictionary:post_dict];
    [request setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    uploadPortraitConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [uploadPortraitConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)uploadMemberInfo:(MemberEntity *)member {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/ModifyCustomer?token=%@", APIAddr, [MemberCoreDataHelper getMemberToken]];
    if (member.gender && member.gender.length != 0)         wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&gender=%@", member.gender]];
    //if (member.name && member.name.length != 0)             wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&name=%@", member.name]];
    if (member.nickName && member.nickName.length != 0)     wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&nickname=%@", member.nickName]];
    if (member.province && member.province.length != 0)     wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&province=%@", member.province]];
    if (member.city && member.city.length != 0)             wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&city=%@", member.city]];
    if (member.area && member.area.length != 0)             wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&area=%@", member.area]];
    if (member.address && member.address.length != 0)       wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&address=%@", member.address]];
    if (member.zipcode && member.zipcode.length != 0)       wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&zipcode=%@", member.zipcode]];
    if (member.receiver && member.receiver.length != 0)     wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&receiver=%@", member.receiver]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    uploadInfoConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [uploadInfoConnection dataTaskWithRequest:request];
    [dataTask resume];

}

- (void)getVerificationCodeWithPhone:(NSString *)phone {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/GetVerificationCode?token=%@&mobilePhone=%@", APIAddr, [MemberCoreDataHelper getMemberToken], phone];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    verificationConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [verificationConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)registerMemberWithPhone:(NSString *)phone andPassword:(NSString *)password andVerificationCode:(NSString *)verification {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/Registered?token=%@&mobilePhone=%@&password=%@&code=%@&mobileField=%@&clientId=%@", APIAddr, [MemberCoreDataHelper getMemberToken], phone, password, verification, [MemberCoreDataHelper getDeviceInfo], [SingleCase singleCase].clientID];
    if ([SingleCase singleCase].deviceToken) { wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&deviceToken=%@", [SingleCase singleCase].deviceToken]]; }
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    registerConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [registerConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)resetPasswordWithPhone:(NSString *)phone andPassword:(NSString *)password andVerificationCode:(NSString *)verification {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/ResetPwd?token=%@&mobilePhone=%@&newPwd=%@&code=%@&mobileField=%@&clientId=%@", APIAddr, [MemberCoreDataHelper getMemberToken], phone, password, verification, [MemberCoreDataHelper getDeviceInfo], [SingleCase singleCase].clientID];
    if ([SingleCase singleCase].deviceToken) { wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&deviceToken=%@", [SingleCase singleCase].deviceToken]]; }
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    resetConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [resetConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)uploadDeviceInfo {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/SetOtherInfo?token=%@&mobileField=%@&clientId=%@", APIAddr, [MemberCoreDataHelper getMemberToken], [MemberCoreDataHelper getDeviceInfo], [SingleCase singleCase].clientID];
    if ([SingleCase singleCase].deviceToken) { wsAddress = [wsAddress stringByAppendingString:[NSString stringWithFormat:@"&deviceToken=%@", [SingleCase singleCase].deviceToken]]; }
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    deviceConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [deviceConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

//favorite stuff
- (void)setFavoriteWithBrandID:(NSString *)brandID {
    NSString *wsAddress = [NSString stringWithFormat:@"%@CRM/SetFavorites?token=%@&brandId=%@", APIAddr, [MemberCoreDataHelper getMemberToken], brandID];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    setFaveriteConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [setFaveriteConnection dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)getFavorites {
    
}

//礼品兑换

- (void)getExchangeList {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Store/GetList?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    //    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"%@",wsAddress);
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    exchangeListConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [exchangeListConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)getExchangeHistory {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Store/GetTradingRecord?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    exchangeHistoryConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [exchangeHistoryConnection dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)getExchangePlaceAndTelephone {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Store/OtherInfo?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    exchangeInfoConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [exchangeInfoConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

//points stuff
- (void)getOnlinePoints {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/GetOnlinePoints?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    //    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    onlinePointsConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [onlinePointsConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)getOnlinePointsHistory{
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/GetOnlinePoints?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    //    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    onlineHistoryConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [onlineHistoryConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}



- (void)setSigninDay {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/SignIn?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    signinConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [signinConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)exchangeInfoViewDidTapExchangeWithExchangeEntity:(ExchangeEntity *)exchangeEntity {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Store/Exchange?token=%@&CommodityId=%i", APIAddr,[MemberCoreDataHelper getMemberToken],[exchangeEntity.exchangeId intValue]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    exchangeConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [exchangeConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)setWheelLottery{
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/GetTurntable?token=%@", APIAddr,[MemberCoreDataHelper getMemberToken]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    wheellotteryConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [wheellotteryConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}


- (void)getOfflinePoints {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/GetOfflinePoints?token=%@&type=0", APIAddr,[MemberCoreDataHelper getMemberToken]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    offlinePointsConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [offlinePointsConnection dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)getOfflinePointsHistory {
    NSString *wsAddress = [NSString stringWithFormat:@"%@Event/GetOfflinePoints?token=%@&type=1", APIAddr,[MemberCoreDataHelper getMemberToken]];
    wsAddress = [wsAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:wsAddress];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    offlineHistoryConnection = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask = [offlineHistoryConnection dataTaskWithRequest:request];
    [dataTask resume];
    
}

- (void)bindOfflineCardWithPhone:(NSString *)phone andName:(NSString *)name andCard:(NSString *)card andVerificationCode:(NSString *)verification {
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    if ([session isEqual:loginConnection]) { loginData = [NSMutableData data]; }
    
    if ([session isEqual:BindConnection]) { BindData = [NSMutableData data]; }
    
    if ([session isEqual:confirmConnection]) { confirmData = [NSMutableData data]; }
    
    if ([session isEqual:uploadPortraitConnection]) { uploadPortraitData = [NSMutableData data]; }
    
    if ([session isEqual:uploadInfoConnection]) { uploadInfoData = [NSMutableData data]; }
    
    if ([session isEqual:verificationConnection]) { verificationData = [NSMutableData data]; }
    
    if ([session isEqual:registerConnection]) { registerData = [NSMutableData data]; }
    
    if ([session isEqual:resetConnection]) { resetData = [NSMutableData data]; }
    
    if ([session isEqual:setFaveriteConnection]) { setFaveriteData = [NSMutableData data]; }
    
    if ([session isEqual:signinConnection]) { signinData = [NSMutableData data];}
    
    if ([session isEqual:wheellotteryConnection]) { wheellotteryData = [NSMutableData data];}
    
    if ([session isEqual:getFaveriteConnection]) { getFaveriteData = [NSMutableData data]; }
    
    if ([session isEqual:onlinePointsConnection]) { onlinePointsData = [NSMutableData data]; }
    
    if ([session isEqual:onlineHistoryConnection]) { onlineHistoryData = [NSMutableData data]; }
    
    if ([session isEqual:offlinePointsConnection]) { offlinePointsData = [NSMutableData data]; }
    
    if ([session isEqual:offlineHistoryConnection]) { offlineHistoryData = [NSMutableData data]; }
    
    if ([session isEqual:offlineBindConnection]) { offlineBindData = [NSMutableData data]; }
    
    if ([session isEqual:exchangeListConnection]) { exchangeListData = [NSMutableData data]; }
    
    if ([session isEqual:exchangeHistoryConnection]) { exchangeHistoryData = [NSMutableData data]; }
    
    if ([session isEqual:exchangeConnection]) { exchangeData = [NSMutableData data]; }
    
    if ([session isEqual:exchangeInfoConnection]) { exchangeInfoData = [NSMutableData data]; }
    
    if ([session isEqual:deviceConnection]) { deviceData = [NSMutableData data]; }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if ([session isEqual:loginConnection]) { [loginData appendData:data]; }
    
    if ([session isEqual:BindConnection]) { [BindData appendData:data]; }
    
    if ([session isEqual:confirmConnection]) { [confirmData appendData:data]; }
    
    if ([session isEqual:uploadPortraitConnection]) { [uploadPortraitData appendData:data]; }
    
    if ([session isEqual:uploadInfoConnection]) { [uploadInfoData appendData:data]; }
    
    if ([session isEqual:verificationConnection]) { [verificationData appendData:data]; }
    
    if ([session isEqual:registerConnection]) { [registerData appendData:data]; }
    
    if ([session isEqual:resetConnection]) { [resetData appendData:data]; }
    
    if ([session isEqual:setFaveriteConnection]) { [setFaveriteData appendData:data]; }
    
    if ([session isEqual:signinConnection]) {[signinData appendData:data];}
    
    if ([session isEqual:wheellotteryConnection]) {[wheellotteryData appendData:data];}
    
    if ([session isEqual:getFaveriteConnection]) { [getFaveriteData appendData:data]; }
    
    if ([session isEqual:onlinePointsConnection]) { [onlinePointsData appendData:data]; }
    
    if ([session isEqual:onlineHistoryConnection]) { [onlineHistoryData appendData:data]; }
    
    if ([session isEqual:offlinePointsConnection]) { [offlinePointsData appendData:data]; }
    
    if ([session isEqual:offlineHistoryConnection]) { [offlineHistoryData appendData:data]; }
    
    if ([session isEqual:offlineBindConnection]) { [offlineBindData appendData:data]; }
    
    if ([session isEqual:exchangeListConnection]) { [exchangeListData appendData:data]; }
    
    if ([session isEqual:exchangeHistoryConnection]) { [exchangeHistoryData appendData:data]; }
    
    if ([session isEqual:exchangeConnection]) { [exchangeData appendData:data]; }
    
    if ([session isEqual:exchangeInfoConnection]) { [exchangeInfoData appendData:data]; }
    
    if ([session isEqual:deviceConnection]) { [deviceData appendData:data]; }
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    
    if ([session isEqual:loginConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:loginData];
            
            if (resDic) {
                MemberEntity *memberEntity = [self getMemberEntity ];
                
                if (resDic[@"customer"][@"HeadImgUrl"] != [NSNull null]) {
                    memberEntity.image = [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]];
                } else
                {
                    memberEntity.image = @"http://mgmt.qpal.dgshare.cn/Uploads/2015/8/31/ad20330b-5097-4341-a763-05c6f79ad88d.png";
                }
                memberEntity.token = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
                memberEntity.phone = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
                //memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
                memberEntity.portrait = [NSData dataWithContentsOfURL:[NSURL URLWithString:memberEntity.image]];
                //memberEntity.onlinePoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Surplus"]];
                if (resDic[@"customer"][@"Surplus"] != [NSNull null]) {
                    memberEntity.onlinePoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Surplus"]];
                } else
                {
                    memberEntity.onlinePoint = @"0";
                }
                if (resDic[@"customer"][@"Accumulation"] != [NSNull null]) {
                    memberEntity.onlineTotalPoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Accumulation"]];
                } else
                {
                    memberEntity.onlineTotalPoint = @"0";
                }
                if (resDic[@"offlinepoint"] !=[NSNull null]){
                    memberEntity.offlinePoint = [NSString stringWithFormat:@"%@", resDic[@"offlinepoint"]];
                } else
                {
                    memberEntity.offlinePoint = @" ";
                }
                if (resDic[@"name"] !=[NSNull null]){
                    memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"name"]];
                    
                } else
                {
                    memberEntity.name = @" ";
                }
                //memberEntity.onlineTotalPoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Accumulation"]];
                //memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
                if (resDic[@"customer"][@"Nickname"] != [NSNull null]) {
                    memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
                } else
                {
                    memberEntity.nickName = @"";
                }
                
                if (resDic[@"customer"][@"Gender"] != [NSNull null]) {
                    memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
                } else
                {
                    memberEntity.gender = @"女";
                }
                memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
                if (resDic[@"customer"][@"Address"] != [NSNull null]) {
                    memberEntity.address = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Address"]];
                } else
                {
                    memberEntity.address = @"";
                }
                
                
                
                //            memberEntity.image = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
                if ([self loginMemberAndSaveMember:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                    [self getOfflinePoints];
                    [self getExchangeHistory];
                    //               [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
                }
                
                [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    if (![self checkFavoriteSync]) {
                        [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                    }
                }]];
            }

        }
    }
    
    if ([session isEqual:BindConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:BindData];
            
            NSString *receiveStr = [[NSString alloc] initWithData:BindData encoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
            if ( p==0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"绑定成功！"];
            }
            
            if (resDic) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.offlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"Dot"]];
                memberEntity.offlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"DotSum"]];
                memberEntity.offlineNumber =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"CardNo"]];
                memberEntity.Bind = YES;
                
                if ([self saveofflinePoints:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Binded" object:nil];
                }
            } else {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.Bind = NO;
                
                [self saveofflinePoints:memberEntity];
            }
        }
    }
    
    if ([session isEqual:confirmConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:confirmData];
            if (resDic) {
                if ([self checkMemberSync]) {
                    MemberEntity *memberEntity = [self getMemberEntity];
                    memberEntity.token = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
                    memberEntity.phone = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
                    memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
                    memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
                    memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
                    memberEntity.image = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
                    if ([self loginMemberAndSaveMember:memberEntity]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                    }
                }
                
                [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    if (![self checkFavoriteSync]) {
                        [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                    }
                }]];
            }
        }
    }
    
    if ([session isEqual:uploadPortraitConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:uploadPortraitData];
            if (resDic) {
                [self syncMemberInfo];
            }
        }
    }
    
    if ([session isEqual:uploadInfoConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:uploadInfoData];
            if (resDic) {
                [self syncMemberInfo];
            }
        }
    }
    
    if ([session isEqual:verificationConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:verificationData];
        }
    }
    
    if ([session isEqual:registerConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:registerData];
            if (resDic) {
                MemberEntity *memberEntity = [MemberEntity getDefaultMemberEntity];
                memberEntity.token         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
                memberEntity.phone         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
                memberEntity.name          = [NSString stringWithFormat:@"%@", @""];
                memberEntity.nickName      = [NSString stringWithFormat:@"%@", @""];
                memberEntity.gender        = [NSString stringWithFormat:@"%@", @""];
                memberEntity.image = @"http://mgmt.qpal.dgshare.cn/Uploads/2015/8/31/ad20330b-5097-4341-a763-05c6f79ad88d.png";
                memberEntity.portrait = [NSData dataWithContentsOfURL:[NSURL URLWithString:memberEntity.image]];
                memberEntity.portrait      = nil;
                [self loginMemberAndSaveMember:memberEntity];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"注册成功！"];
            }
        }
    }
    
    if ([session isEqual:resetConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:resetData];
            if (resDic) {
                MemberEntity *memberEntity = [MemberEntity getDefaultMemberEntity];
                memberEntity.token         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
                memberEntity.phone         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
                memberEntity.name          = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
                memberEntity.nickName      = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
                memberEntity.gender        = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
                memberEntity.image         = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
                [self loginMemberAndSaveMember:memberEntity];
                
                [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    if (![self checkFavoriteSync]) {
                        [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                    }
                }]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"重置成功！"];
            }
        }
    }
    
    if ([session isEqual:setFaveriteConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:setFaveriteData];
            if (resDic) {
                [BrandCoreDataHelper syncFavorite];
            }
        }
    }
    
    if ([session isEqual:signinConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:signinData];
            NSString *receiveStr = [[NSString alloc]initWithData:signinData encoding:NSUTF8StringEncoding];
            
            NSError *error;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recode" object:nil userInfo:res];
            
            if ( p == 0 ) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
                memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
                memberEntity.signinDay =  [NSString stringWithFormat:@"%@",resDic [@"current"]];
                if ([self saveonlinePoints:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"签到成功！"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
                }
            } else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"今天您已签过到啦！"];
            }
        }
    }
    
    if ([session isEqual:wheellotteryConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:wheellotteryData];
            NSString *receiveStr = [[NSString alloc]initWithData:wheellotteryData encoding:NSUTF8StringEncoding];
            NSError *error;
            
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkgamewheelallowed" object:nil userInfo:res];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getgamewheelBonus" object:nil userInfo:resDic];
            
            if ( p == 0 ) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
                memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
                memberEntity.gamewheelBonus = [NSString stringWithFormat:@"%@",resDic[@"bonus"][@"code"]];
                
                if ([self saveonlinePoints:memberEntity]) {
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
                }
            }else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"积分不足！"];
            }

        }
    }
    
    if ([session isEqual:getFaveriteConnection]) {
        if(error == nil)
        {
            
        }
    }
    
    if ([session isEqual:onlinePointsConnection]) {
        if(error == nil)
        {
            NSString *receiveStr = [[NSString alloc]initWithData:onlinePointsData encoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            NSDictionary *resDic = [JSONHelper dataToDictionary:onlinePointsData];
            if (resDic) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
                memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
                memberEntity.signinDay =  [NSString stringWithFormat:@"%@",resDic[@"current"]];
                
                if ([self saveonlinePoints:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
                }
            }

        }
    }
    
    if ([session isEqual:onlineHistoryConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:onlineHistoryData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scorehistory" object:nil userInfo:resDic];
            if (resDic) {
                if ([self saveHistorywithDictionary:resDic]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateExchangeHistory" object:nil];
                }
            }
        }
    }
    
    if ([session isEqual:offlinePointsConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:offlinePointsData];
            NSString *receiveStr = [[NSString alloc] initWithData:offlinePointsData encoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            
            //int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ifBinded" object:nil userInfo:res];
            if (resDic) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.offlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"Dot"]];
                memberEntity.offlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"DotSum"]];
                memberEntity.offlineNumber =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"CardNo"]];
                memberEntity.Bind = YES;
                
                if ([self saveofflinePoints:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateofflinePoint" object:nil];
                }
            } else {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.Bind = NO;
                
                [self saveofflinePoints:memberEntity];
            }

        }
    }
    
    if ([session isEqual:offlineHistoryConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:offlineHistoryData];
            if (resDic) {
                [self saveofflineHistorywithDictionary:resDic];
            }
        }
    }
    
    if ([session isEqual:offlineBindConnection]) {
        if(error == nil)
        {
            
        }
    }
    
    if ([session isEqual:exchangeListConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeListData];
            if (resDic) {
                [self saveExchangeListwithDictionary:resDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateExchange" object:nil];
            }
        }
    }
    
    if ([session isEqual:exchangeHistoryConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeHistoryData];
            
            if (resDic) {
                [self saveExchangeHistorywithDictionary:resDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:nil];
            }
        }
    }
    
    if ([session isEqual:exchangeConnection]) {
        if(error == nil)
        {
            NSString *receiveStr = [[NSString alloc]initWithData:exchangeData encoding:NSUTF8StringEncoding];
            
            NSError *error;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"recode" object:nil userInfo:res];
            
            if ( p == 0 ) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"恭喜，兑换成功！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hasExchanged" object:nil];
            } else
            {
                if (p == 906) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"您的线上积分不足"];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"库存不足"];
                }
            }

        }
    }
    
    if ([session isEqual:exchangeInfoConnection]) {
        if(error == nil)
        {
            NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeInfoData];
            
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.exchangeTelephone =  [NSString stringWithFormat:@"%@",resDic[@"title"]];
            memberEntity.exchangePlace =  [NSString stringWithFormat:@"%@",resDic[@"address"]];
            
            [self saveofflinePoints:memberEntity];
        }
    }
    
    if ([session isEqual:deviceConnection]) {
        if(error == nil)
        {
            
        }
    }
}

#pragma mark Connection Delegate Method
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([connection isEqual:loginConnection]) { loginData = [NSMutableData data]; }
    
    if ([connection isEqual:BindConnection]) { BindData = [NSMutableData data]; }
    
    if ([connection isEqual:confirmConnection]) { confirmData = [NSMutableData data]; }
    
    if ([connection isEqual:uploadPortraitConnection]) { uploadPortraitData = [NSMutableData data]; }
    
    if ([connection isEqual:uploadInfoConnection]) { uploadInfoData = [NSMutableData data]; }
    
    if ([connection isEqual:verificationConnection]) { verificationData = [NSMutableData data]; }
    
    if ([connection isEqual:registerConnection]) { registerData = [NSMutableData data]; }
    
    if ([connection isEqual:resetConnection]) { resetData = [NSMutableData data]; }
    
    if ([connection isEqual:setFaveriteConnection]) { setFaveriteData = [NSMutableData data]; }
    
    if ([connection isEqual:signinConnection]) { signinData = [NSMutableData data];}
    
    if ([connection isEqual:wheellotteryConnection]) { wheellotteryData = [NSMutableData data];}
    
    if ([connection isEqual:getFaveriteConnection]) { getFaveriteData = [NSMutableData data]; }
    
    if ([connection isEqual:onlinePointsConnection]) { onlinePointsData = [NSMutableData data]; }
    
    if ([connection isEqual:onlineHistoryConnection]) { onlineHistoryData = [NSMutableData data]; }
    
    if ([connection isEqual:offlinePointsConnection]) { offlinePointsData = [NSMutableData data]; }
    
    if ([connection isEqual:offlineHistoryConnection]) { offlineHistoryData = [NSMutableData data]; }
    
    if ([connection isEqual:offlineBindConnection]) { offlineBindData = [NSMutableData data]; }
    
    if ([connection isEqual:exchangeListConnection]) { exchangeListData = [NSMutableData data]; }
    
    if ([connection isEqual:exchangeHistoryConnection]) { exchangeHistoryData = [NSMutableData data]; }
    
    if ([connection isEqual:exchangeConnection]) { exchangeData = [NSMutableData data]; }
    
    if ([connection isEqual:exchangeInfoConnection]) { exchangeInfoData = [NSMutableData data]; }
    
    if ([connection isEqual:deviceConnection]) { deviceData = [NSMutableData data]; }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([connection isEqual:loginConnection]) { [loginData appendData:data]; }
    
    if ([connection isEqual:BindConnection]) { [BindData appendData:data]; }
    
    if ([connection isEqual:confirmConnection]) { [confirmData appendData:data]; }
    
    if ([connection isEqual:uploadPortraitConnection]) { [uploadPortraitData appendData:data]; }
    
    if ([connection isEqual:uploadInfoConnection]) { [uploadInfoData appendData:data]; }
    
    if ([connection isEqual:verificationConnection]) { [verificationData appendData:data]; }
    
    if ([connection isEqual:registerConnection]) { [registerData appendData:data]; }
    
    if ([connection isEqual:resetConnection]) { [resetData appendData:data]; }
    
    if ([connection isEqual:setFaveriteConnection]) { [setFaveriteData appendData:data]; }
    
    if ([connection isEqual:signinConnection]) {[signinData appendData:data];}
    
    if ([connection isEqual:wheellotteryConnection]) {[wheellotteryData appendData:data];}
    
    if ([connection isEqual:getFaveriteConnection]) { [getFaveriteData appendData:data]; }
    
    if ([connection isEqual:onlinePointsConnection]) { [onlinePointsData appendData:data]; }
    
    if ([connection isEqual:onlineHistoryConnection]) { [onlineHistoryData appendData:data]; }
    
    if ([connection isEqual:offlinePointsConnection]) { [offlinePointsData appendData:data]; }
    
    if ([connection isEqual:offlineHistoryConnection]) { [offlineHistoryData appendData:data]; }
    
    if ([connection isEqual:offlineBindConnection]) { [offlineBindData appendData:data]; }
    
    if ([connection isEqual:exchangeListConnection]) { [exchangeListData appendData:data]; }
    
    if ([connection isEqual:exchangeHistoryConnection]) { [exchangeHistoryData appendData:data]; }
    
    if ([connection isEqual:exchangeConnection]) { [exchangeData appendData:data]; }
    
    if ([connection isEqual:exchangeInfoConnection]) { [exchangeInfoData appendData:data]; }
    
    if ([connection isEqual:deviceConnection]) { [deviceData appendData:data]; }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([connection isEqual:loginConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:loginData];
        
        if (resDic) {
            MemberEntity *memberEntity = [self getMemberEntity ];
            
            if (resDic[@"customer"][@"HeadImgUrl"] != [NSNull null]) {
                memberEntity.image = [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]];
            } else
            {
                memberEntity.image = @"http://mgmt.qpal.dgshare.cn/Uploads/2015/8/31/ad20330b-5097-4341-a763-05c6f79ad88d.png";
            }
            memberEntity.token = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
            memberEntity.phone = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
            //memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
            memberEntity.portrait = [NSData dataWithContentsOfURL:[NSURL URLWithString:memberEntity.image]];
            //memberEntity.onlinePoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Surplus"]];
            if (resDic[@"customer"][@"Surplus"] != [NSNull null]) {
                memberEntity.onlinePoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Surplus"]];
            } else
            {
                memberEntity.onlinePoint = @"0";
            }
            if (resDic[@"customer"][@"Accumulation"] != [NSNull null]) {
                memberEntity.onlineTotalPoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Accumulation"]];
            } else
            {
                memberEntity.onlineTotalPoint = @"0";
            }
            if (resDic[@"offlinepoint"] !=[NSNull null]){
                memberEntity.offlinePoint = [NSString stringWithFormat:@"%@", resDic[@"offlinepoint"]];
            } else
            {
                memberEntity.offlinePoint = @" ";
            }
            if (resDic[@"name"] !=[NSNull null]){
                memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"name"]];
                
            } else
            {
                memberEntity.name = @" ";
            }
            //memberEntity.onlineTotalPoint = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Accumulation"]];
            //memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
            if (resDic[@"customer"][@"Nickname"] != [NSNull null]) {
                memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
            } else
            {
                memberEntity.nickName = @"";
            }
            
            if (resDic[@"customer"][@"Gender"] != [NSNull null]) {
                memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
            } else
            {
                memberEntity.gender = @"女";
            }
            memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
            if (resDic[@"customer"][@"Address"] != [NSNull null]) {
                memberEntity.address = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Address"]];
            } else
            {
                memberEntity.address = @"";
            }
            
            
            
            //            memberEntity.image = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
            if ([self loginMemberAndSaveMember:memberEntity]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                [self getOfflinePoints];
                [self getExchangeHistory];
                //               [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                if (![self checkFavoriteSync]) {
                    [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                }
            }]];
        }
    }
    
    if ([connection isEqual:BindConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:BindData];
        
        NSString *receiveStr = [[NSString alloc] initWithData:BindData encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
        if ( p==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"绑定成功！"];
        }
        
        if (resDic) {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.offlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"Dot"]];
            memberEntity.offlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"DotSum"]];
            memberEntity.offlineNumber =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"CardNo"]];
            memberEntity.Bind = YES;
            
            if ([self saveofflinePoints:memberEntity]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Binded" object:nil];
            }
        } else {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.Bind = NO;
            
            [self saveofflinePoints:memberEntity];
        }
    }
    
    if ([connection isEqual:exchangeListConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeListData];
        if (resDic) {
            [self saveExchangeListwithDictionary:resDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateExchange" object:nil];
        }
    }
    
    if ([connection isEqual:exchangeHistoryConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeHistoryData];
        
        if (resDic) {
            [self saveExchangeHistorywithDictionary:resDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:nil];
        }
    }
    
    if ([connection isEqual:exchangeInfoConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeInfoData];

        MemberEntity *memberEntity = [self getMemberEntity];
        memberEntity.exchangeTelephone =  [NSString stringWithFormat:@"%@",resDic[@"title"]];
        memberEntity.exchangePlace =  [NSString stringWithFormat:@"%@",resDic[@"address"]];
                                           
        [self saveofflinePoints:memberEntity];
        }
    
    if ([connection isEqual:exchangeConnection]) {
        //NSDictionary *resDic = [JSONHelper dataToDictionary:exchangeData];
        NSString *receiveStr = [[NSString alloc]initWithData:exchangeData encoding:NSUTF8StringEncoding];
        
        NSError *error;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"recode" object:nil userInfo:res];
        
        if ( p == 0 ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"恭喜，兑换成功！"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasExchanged" object:nil];
        } else
        {
            if (p == 906) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"您的线上积分不足"];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"库存不足"];
            }
        }
        
    }
    
    if ([connection isEqual:onlinePointsConnection]) {
              NSString *receiveStr = [[NSString alloc]initWithData:onlinePointsData encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *resDic = [JSONHelper dataToDictionary:onlinePointsData];
        if (resDic) {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
            memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
            memberEntity.signinDay =  [NSString stringWithFormat:@"%@",resDic[@"current"]];
            
            if ([self saveonlinePoints:memberEntity]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
            }
        }
    }
    
    if ([connection isEqual:onlineHistoryConnection]) {
        
        NSDictionary *resDic = [JSONHelper dataToDictionary:onlineHistoryData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scorehistory" object:nil userInfo:resDic];
        if (resDic) {
            if ([self saveHistorywithDictionary:resDic]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateExchangeHistory" object:nil];
            }
        }
    }
    
    if ([connection isEqual:offlinePointsConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:offlinePointsData];
        NSString *receiveStr = [[NSString alloc] initWithData:offlinePointsData encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        //int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ifBinded" object:nil userInfo:res];
        if (resDic) {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.offlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"Dot"]];
            memberEntity.offlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"DotSum"]];
            memberEntity.offlineNumber =  [NSString stringWithFormat:@"%@",resDic[@"data"][@"QueryCardResult"][@"CardNo"]];
            memberEntity.Bind = YES;
            
            if ([self saveofflinePoints:memberEntity]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateofflinePoint" object:nil];
            }
        } else {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.Bind = NO;
            
            [self saveofflinePoints:memberEntity];
        }
    }
    
    if ([connection isEqual:offlineHistoryConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:offlineHistoryData];
        if (resDic) {
            [self saveofflineHistorywithDictionary:resDic];
        }
    }
    
    if ([connection isEqual:signinConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:signinData];
        NSString *receiveStr = [[NSString alloc]initWithData:signinData encoding:NSUTF8StringEncoding];
        
        NSError *error;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recode" object:nil userInfo:res];
        
        if ( p == 0 ) {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
            memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
            memberEntity.signinDay =  [NSString stringWithFormat:@"%@",resDic [@"current"]];
            if ([self saveonlinePoints:memberEntity]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"签到成功！"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
            }
        } else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"今天您已签过到啦！"];
        }
    }

    if ([connection isEqual:wheellotteryConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:wheellotteryData];
        NSString *receiveStr = [[NSString alloc]initWithData:wheellotteryData encoding:NSUTF8StringEncoding];
        NSError *error;
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[receiveStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        int p = [[NSString stringWithFormat:@"%@",res[@"status"][@"resCode"]] intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkgamewheelallowed" object:nil userInfo:res];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getgamewheelBonus" object:nil userInfo:resDic];
        
        if ( p == 0 ) {
            MemberEntity *memberEntity = [self getMemberEntity];
            memberEntity.onlinePoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Surplus"]];
            memberEntity.onlineTotalPoint =  [NSString stringWithFormat:@"%@",resDic[@"customer"][@"Accumulation"]];
            memberEntity.gamewheelBonus = [NSString stringWithFormat:@"%@",resDic[@"bonus"][@"code"]];
            
            if ([self saveonlinePoints:memberEntity]) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateonlinePoint" object:nil];
            }
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"积分不足！"];
        }
    }
    
    if ([connection isEqual:confirmConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:confirmData];
        if (resDic) {
            if ([self checkMemberSync]) {
                MemberEntity *memberEntity = [self getMemberEntity];
                memberEntity.token = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
                memberEntity.phone = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
                memberEntity.name = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
                memberEntity.nickName = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
                memberEntity.gender = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
                memberEntity.image = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
                if ([self loginMemberAndSaveMember:memberEntity]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
                }
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                if (![self checkFavoriteSync]) {
                    [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                }
            }]];
        }
    }
    
    if ([connection isEqual:uploadPortraitConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:uploadPortraitData];
        if (resDic) {
            [self syncMemberInfo];
        }
    }
    
    if ([connection isEqual:uploadInfoConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:uploadInfoData];
        if (resDic) {
            [self syncMemberInfo];
        }
    }
    
    if ([connection isEqual:verificationConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:verificationData];
    }
    
    if ([connection isEqual:registerConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:registerData];
        if (resDic) {
            MemberEntity *memberEntity = [MemberEntity getDefaultMemberEntity];
            memberEntity.token         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
            memberEntity.phone         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
            memberEntity.name          = [NSString stringWithFormat:@"%@", @""];
            memberEntity.nickName      = [NSString stringWithFormat:@"%@", @""];
            memberEntity.gender        = [NSString stringWithFormat:@"%@", @""];
            memberEntity.image = @"http://mgmt.qpal.dgshare.cn/Uploads/2015/8/31/ad20330b-5097-4341-a763-05c6f79ad88d.png";
            memberEntity.portrait = [NSData dataWithContentsOfURL:[NSURL URLWithString:memberEntity.image]];
            memberEntity.portrait      = nil;
            [self loginMemberAndSaveMember:memberEntity];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"注册成功！"];
        }
    }
    
    if ([connection isEqual:resetConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:resetData];
        if (resDic) {
            MemberEntity *memberEntity = [MemberEntity getDefaultMemberEntity];
            memberEntity.token         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Token"]];
            memberEntity.phone         = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"MobilePhone"]];
            memberEntity.name          = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Name"]];
            memberEntity.nickName      = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Nickname"]];
            memberEntity.gender        = [NSString stringWithFormat:@"%@", resDic[@"customer"][@"Gender"]];
            memberEntity.image         = [[NSString stringWithFormat:@"%@", resDic[@"customer"][@"HeadImgUrl"]] length] > 0 ? [NSString stringWithFormat:@"%@%@", APIAddr, resDic[@"customer"][@"HeadImgUrl"]] : nil;
            [self loginMemberAndSaveMember:memberEntity];
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                if (![self checkFavoriteSync]) {
                    [self updateFavoriteBrandWithBrandIDs:resDic[@"brandIds"]];
                }
            }]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"memberLogin" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"重置成功！"];
        }
    }
    
    if ([connection isEqual:setFaveriteConnection]) {
        NSDictionary *resDic = [JSONHelper dataToDictionary:setFaveriteData];
        if (resDic) {
            [BrandCoreDataHelper syncFavorite];
        }
    }
    
    if ([connection isEqual:deviceConnection]) {
        
    }
    
    if ([connection isEqual:getFaveriteConnection]) {
    }
    
    if ([connection isEqual:onlinePointsConnection]) {
    }
    
    if ([connection isEqual:onlineHistoryConnection]) {
    }
    
    if ([connection isEqual:offlinePointsConnection]) {
    }
    
    if ([connection isEqual:offlineHistoryConnection]) {
    }
    
    if ([connection isEqual:offlineBindConnection]) {
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"网络异常！请检查网络连接状况！"];
    }];
}*/

#pragma mark - local
- (BOOL)checkMemberSync {
    return [MemberCoreDataHelper checkSync];
}

- (MemberEntity *)getMemberEntity {
    return [MemberCoreDataHelper getMemberEntity];
}

- (BOOL)updateMemberInfo:(MemberEntity *)memberEntity {
    if (memberEntity == nil) {
        memberEntity = [self getMemberEntity];
    }
    
    if ([MemberCoreDataHelper updateMemberInfo:memberEntity]) {
        [self uploadMemberInfo:memberEntity];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)updateMemberPortrait:(MemberEntity *)memberEntity {
    if (memberEntity == nil) {
        memberEntity = [self getMemberEntity];
    }
    
    if ([MemberCoreDataHelper updateMemberInfo:memberEntity]) {
        [self uploadMemberPortrait:memberEntity.portrait];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)syncMemberInfo {
    return [MemberCoreDataHelper syncMemberInfo];
}

- (BOOL)getLoginStatus {
    return [MemberCoreDataHelper checkLoginStatus];
}

- (BOOL)getBindStatus {
    return [MemberCoreDataHelper checkBindStatus];
}

- (BOOL)loginMemberAndSaveMember:(MemberEntity *)memberEntity {
    return [MemberCoreDataHelper loginMemberAndSaveMember:memberEntity];
}

- (BOOL)logoutMember {
    return [MemberCoreDataHelper logoutMember];;
}

- (BOOL)saveonlinePoints:(MemberEntity *)memberEntity{
    return [MemberCoreDataHelper saveonlinePoints:memberEntity];
}

- (BOOL)saveofflinePoints:(MemberEntity *)memberEntity{
    return [MemberCoreDataHelper saveofflinePoints:memberEntity];
}
/*
 - (BOOL)saveScoreHistorywithDictionary:(NSDictionary *)resDic{
 return [MemberCoreDataHelper saveScoreHistorywithDictionary:(NSDictionary *)resDic];
 }*/

- (BOOL)saveHistorywithDictionary:(NSDictionary *)resDic{
    return [MemberCoreDataHelper saveHistorywithDictionary:resDic];
}

- (BOOL)saveExchangeListwithDictionary:(NSDictionary *)resDic{
    return [MemberCoreDataHelper saveExchangeListwithDictionary:resDic];
}

- (BOOL)saveExchangeHistorywithDictionary:(NSDictionary *)resDic{
    return [MemberCoreDataHelper saveExchangeHistorywithDictionary:resDic];
}

- (BOOL)saveofflineHistorywithDictionary:(NSDictionary *)resDic{
    return [MemberCoreDataHelper saveofflineHistorywithDictionary:resDic];
}
/*
 - (BOOL)signinAndSaveMember:(MemberEntity *)memberEntity{
 return [MemberCoreDataHelper signinAndSaveMember:memberEntity];
 }
 */


//favorite stuff
- (NSString *)checkFavoriteSync {
    return [BrandCoreDataHelper checkFavoriteSync];
}

- (BOOL)updateFavoriteBrandWithBrandIDs:(NSArray *)brandIDs {
    return [BrandCoreDataHelper setFavorite:brandIDs];
}

- (ShopEntity *)setLocalFavoriteWithBrandID:(ShopEntity *)brand {
    return [BrandCoreDataHelper setFavoriteBrandWithBrandID:brand];
}

- (BOOL)syncFavorite {
    return [BrandCoreDataHelper syncFavorite];
}

- (BOOL)clearFavorite {
    return [BrandCoreDataHelper clearFavorite];
}

//congfig stuff
- (NSString *)getLastUpdateDate {
    return [ConfigCoreDataHelper getUpdateDate];
}

- (BOOL)checkAppGuideSign:(NSString *)guideSign {
    return [ConfigCoreDataHelper checkAppGuideSign:guideSign];
}

- (NSString *)getMemberToken {
    return [MemberCoreDataHelper getMemberToken];
}


- (NSString *)getDeviceInfo {
    return [MemberCoreDataHelper getDeviceInfo];
}

@end
