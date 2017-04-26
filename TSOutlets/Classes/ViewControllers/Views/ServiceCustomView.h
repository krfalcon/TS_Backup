//
//  ServiceCustomView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/3.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "ServiceEntity.h"
#import "FXBlurView.h"
#import "MDIncrementalImageView.h"

@protocol ServiceCustomViewDelegate;

@interface ServiceCustomView : TempletView<UIScrollViewDelegate,MDIncrementalImageViewDelegate>
{
    FXBlurView*                                                     blurView;
    UIView*                                                         lowerView;
}

@property (weak,nonatomic)   id<ServiceCustomViewDelegate>          delegate;

- (void)getServiceCustomWithString:(NSString *)faqurl;

@end

@protocol ServiceCustomViewDelegate <NSObject>

- (void)serviceCustomView:(ServiceCustomView *)serviceCustomView didStartDragScrollView:(UIScrollView *)scrollView;
- (void)serviceCustomViewDidTapReplyButton;

@end