//
//  SetView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"

@protocol SetViewDelegate;

@interface SetView : TempletView
{
    UIScrollView*                   setScrollView;
    NSString*                       appVersion;
    NSString*                       lVersion;
    NSString*                       latestVersion;
    NSString*                       trackViewUrl;
    NSString*                       trackName;
    NSString*                          appID;
}

@property (weak, nonatomic) id<SetViewDelegate>        delegate;

@end

@protocol SetViewDelegate <NSObject>

- (void)setViewDidTapFeedbackButton;
- (void)setViewDidTapaboutUsButton;

@end