//
//  SetViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!setView) {
        setView = [[SetView alloc] initWithFrame:self.view.bounds];
        [setView setDelegate:self];
        [self.view addSubview:setView];
    }
    
}

- (void)setViewDidTapFeedbackButton {
    [self pushViewControllerWithViewControllerType:ViewControllerTypeSetFeedback andParameter:nil];
}

- (void)setViewDidTapaboutUsButton {
    [self pushViewControllerWithViewControllerType:ViewControllerTypeSetAboutUs andParameter:nil];
}

@end
