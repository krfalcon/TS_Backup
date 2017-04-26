//
//  AboutUsView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/6/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "AboutUsView.h"

@implementation AboutUsView

- (void)initView {
    aboutUsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [self addSubview:aboutUsView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:aboutUsView.bounds];
    [imageView setImage:[UIImage imageNamed:@"aboutus"]];
    [aboutUsView addSubview:imageView];
}

@end
