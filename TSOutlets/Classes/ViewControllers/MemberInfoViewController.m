//
//  MemberInfoViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/12.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MemberInfoViewController.h"

@interface MemberInfoViewController ()

@end

@implementation MemberInfoViewController

#pragma mark - InitView

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!parameter) return;
    memberAPI = [[MemberAPITool alloc] init];
    _memberEntity = [memberAPI getMemberEntity];
    //    [memberAPI getOnlinePoints];
    
    if (!memberInfoView && [[parameter valueForKey:@"type"] isEqualToString:@"member"]) {
        memberInfoView = [[MemberInfoView alloc] initWithFrame:self.view.bounds];
        [memberInfoView setDelegate:self];
        [self.view addSubview:memberInfoView];
        
        self.currentView = memberInfoView;
        
        [memberInfoView getInfo:_memberEntity];
        /*   } else if (!onlinePointView && [[parameter valueForKey:@"type"] isEqualToString:@"online"]) {
         onlinePointView = [[OnlinePointView alloc] initWithFrame:self.view.bounds];
         [onlinePointView setDelegate:self];
         [self.view addSubview:onlinePointView];
         
         self.currentView = onlinePointView;
         
         [onlinePointView getInfo:_memberEntity];*/
    } else if (!onlinePointView && [[parameter valueForKey:@"type"] isEqualToString:@"online"])
    {
        signinRescode   = 903;
        [memberAPI getOnlinePoints];
        [memberAPI getOnlinePointsHistory];
        _memberEntity   = [memberAPI getMemberEntity];
        
        
        onlinePointView = [[OnlinePointView alloc] initWithFrame:self.view.bounds];
        [onlinePointView setDelegate:self];
        [self.view addSubview:onlinePointView];
        
        self.currentView = onlinePointView;
        [onlinePointView getInfo:_memberEntity];
        i = [_memberEntity.signinDay intValue] + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rescode:) name:@"recode" object:nil];
        
    } else if ([[parameter valueForKey:@"type"] isEqualToString:@"offline"]) {
        memberAPI = [[MemberAPITool alloc] init];
        [memberAPI getOfflinePoints];
        [memberAPI getOfflinePointsHistory];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkifBinded:) name:@"ifBinded" object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Binded) name:@"Binded" object:nil];
}

- (void)rescode:(NSNotification *) notification
{
    signinRescodeDic = [notification userInfo];
    signinRescode    = [signinRescodeDic[@"status"][@"resCode"] intValue];
    int p = i % 7 ;
    if (signinRescode == 0 ) {
        [onlinePointView reloadProgressViewandProgress:p];
        i++;
        [memberAPI getOnlinePointsHistory];
    }
}

#pragma mark - Notification

- (void)Binded {
    _memberEntity = [memberAPI getMemberEntity];
    [offlinePointBindView removeFromSuperview];
    offlinePointView = [[OfflinePointView alloc] initWithFrame:self.view.bounds];
    [offlinePointView setDelegate:self];
    [self.view addSubview:offlinePointView];
    self.currentView = offlinePointView;
    
    [offlinePointView getInfo:_memberEntity];
}

- (void)checkifBinded:(NSNotification *) notification
{
    ifBindedRescodeDic = [notification userInfo];
    ifBindedRescode = [ifBindedRescodeDic[@"status"][@"resCode"] intValue];
    if (ifBindedRescode == 0) {
        offlinePointView = [[OfflinePointView alloc] initWithFrame:self.view.bounds];
        [offlinePointView setDelegate:self];
        [self.view addSubview:offlinePointView];
        self.currentView = offlinePointView;
        
        [offlinePointView getInfo:_memberEntity];
    } else {
        offlinePointBindView = [[OfflinePointBindView alloc] initWithFrame:self.view.bounds];
        [offlinePointBindView setDelegate:self];
        [self.view addSubview:offlinePointBindView];
        
        self.currentView = offlinePointBindView;
    }
}

#pragma mark - Member Info Delegate

- (void)memberInfoViewDidResetPasswordButton {
    [self pushViewControllerWithViewControllerType:ViewControllerTypeReset andParameter:nil];
}

- (void)memberInfoViewDidImageButtonWithType:(NSString *)type {
    [self didTappedImagePickerWithTpye:type];
}

- (void)memberInfoViewDidEditButtonWithType:(int)type andMemberEntity:(MemberEntity *)memberEntity{
    [self didTappedEditViewWithTpye:type andMemberEntity:memberEntity];
}

- (void)memberInfoViewDidSaveMemberEntity:(MemberEntity *)memberEntity {
    if ([memberAPI updateMemberInfo:memberEntity]) {
        _memberEntity = memberEntity;
    }
}

- (void)memberInfoViewDidSavePortrait:(MemberEntity *)memberEntity {
    if ([memberAPI updateMemberPortrait:memberEntity]) {
        _memberEntity = memberEntity;
    }
}

#pragma mark - Point Views Delegate
- (void)scrollViewDidScroll {
    [self wheelViewShouldHide];
}

- (void)onlinePointViewDidTapDetailButton {
    [self pushViewControllerWithViewControllerType:ViewControllerTypeOnlineDetail andParameter:nil];
}

- (void)onlinPointViewDidTapSigninRulerButton{
    [self pushViewControllerWithViewControllerType:ViewControllerTypeSigninRuler andParameter:nil];
}

- (void)onlinePointViewDidTapSigninButton {
    [memberAPI setSigninDay];
}

- (void)offlinePointViewDidTapDetailButton {
    [self pushViewControllerWithViewControllerType:ViewControllerTypeOfflineDetail andParameter:nil];
}

/*
- (void)offlinePointBindViewDidTapBindButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
    
    if (!offlinePointView) {
        offlinePointView = [[OfflinePointView alloc] initWithFrame:self.view.bounds];
        [offlinePointView setDelegate:self];
        [self.view addSubview:offlinePointView];
        
        [offlinePointView getInfo:nil];
    }
    self.nextView = offlinePointView;
    [self showNextView];
}*/

- (void)offlinePointBindViewDidTapBindButtonWithCardNumber:(NSString *)cardNumber andPassword:(NSString *)password {
    [memberAPI bindWithCardNumber:cardNumber andPassword:password];
}

#pragma mark - Wheel View Button

- (void)wheelViewTappedButton1 {
    [self popToIndexViewController];
}

- (void)wheelViewTappedButton2 {
    //BOOL isBanded = NO;
    [memberAPI getOfflinePoints];
    if (ifBindedRescode == 0) {
        if (!offlinePointView) {
            offlinePointView = [[OfflinePointView alloc] initWithFrame:self.view.bounds];
            [offlinePointView setDelegate:self];
            [self.view addSubview:offlinePointView];
            
            [offlinePointView getInfo:_memberEntity];
        }
        self.nextView = offlinePointView;
    } else {
        if (!offlinePointBindView) {
            offlinePointBindView = [[OfflinePointBindView alloc] initWithFrame:self.view.bounds];
            [offlinePointBindView setDelegate:self];
            [self.view addSubview:offlinePointBindView];
            
            self.currentView = offlinePointBindView;
        }
        self.nextView = offlinePointBindView;
    }
    [self showNextView];
}

- (void)wheelViewTappedButton3 {
    //    [self pushViewControllerWithViewControllerType:ViewControllerTypeOnline andParameter:nil];
    signinRescode   = 903;
    [memberAPI getOnlinePoints];
    [memberAPI getOnlinePointsHistory];
    _memberEntity   = [memberAPI getMemberEntity];
    
    if (!onlinePointView) {
        onlinePointView = [[OnlinePointView alloc] initWithFrame:self.view.bounds];
        [onlinePointView setDelegate:self];
        [self.view addSubview:onlinePointView];
        
        [onlinePointView getInfo:_memberEntity];
        i = [_memberEntity.signinDay intValue] + 1;
    }
    self.nextView = onlinePointView;
    [self showNextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rescode:) name:@"recode" object:nil];
    /*
     if (!onlinePointView) {
     onlinePointView = [[OnlinePointView alloc] initWithFrame:self.view.bounds];
     [onlinePointView setDelegate:self];
     [self.view addSubview:onlinePointView];
     
     [onlinePointView getInfo:_memberEntity];
     }
     
     self.nextView = onlinePointView;
     [self showNextView];
     */
}


- (void)wheelViewTappedButton4 {
    if (!memberInfoView) {
        memberInfoView = [[MemberInfoView alloc] initWithFrame:self.view.bounds];
        [memberInfoView setDelegate:self];
        [self.view addSubview:memberInfoView];
        
        [memberInfoView getInfo:_memberEntity];
    }
    
    self.nextView = memberInfoView;
    [self showNextView];
}

- (void)wheelViewTappedButton5 {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"该功能暂未开放，敬请期待！"];
    //[self popToIndexViewController];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchange andParameter:nil];
}

@end
