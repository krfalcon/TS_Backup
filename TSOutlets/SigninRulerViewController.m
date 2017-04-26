//
//  SigninRulerViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 9/1/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "SigninRulerViewController.h"

@interface SigninRulerViewController ()

@end

@implementation SigninRulerViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!signinRulerView) {
        signinRulerView = [[SigninRulerView alloc] initWithFrame:self.view.bounds];
        //    [signinRulerView setDelegate:self];
        [self.view addSubview:signinRulerView];
    }
}

@end
