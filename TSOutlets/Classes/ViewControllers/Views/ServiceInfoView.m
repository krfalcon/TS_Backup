//
//  ServiceInfoView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/10.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "ServiceInfoView.h"

@implementation ServiceInfoView

- (void)getServiceInfoWithString:(NSString *)introUrl{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [scrollView setDelegate:self];
    [self addSubview:scrollView];
    
    MDIncrementalImageView *contentImage = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(0 , 0 , self.frame.size.width, self.frame.size.width * 4353 / 700)];
    [contentImage setImageUrl:[NSURL URLWithString:introUrl]];
    [contentImage setIsBlack:NO];
    [contentImage setShowLoadingIndicatorWhileLoading:YES];
    [scrollView addSubview:contentImage];

    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 0 * self.scale + contentImage.frame.size.height)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(serviceInfoView:didStartDragScrollView:)]) {
        [_delegate serviceInfoView:self didStartDragScrollView:scrollView ];
    }
}

@end
