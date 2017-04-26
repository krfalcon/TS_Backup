//
//  AboutUsViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/6/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!aboutUsView) {
        aboutUsView = [[AboutUsView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:aboutUsView];
    }
    
}

@end
