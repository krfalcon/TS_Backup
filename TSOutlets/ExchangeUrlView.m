//
//  ExchangeUrlView.m
//  TSOutlets
//
//  Created by KDC on 3/23/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "ExchangeUrlView.h"

@implementation ExchangeUrlView

- (void)getInfo:(ExchangeHistoryEntity *)ety {
    MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake( 77/2  * self.scale, 100 * self.scale, 300.f * self.scale, 300.f * self.scale)];
    [imageView setImageUrl:[NSURL URLWithString:ety.qrCodeUrl]];
    [imageView setShowLoadingIndicatorWhileLoading:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:imageView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 * self.scale, 370 * self.scale, 325 * self.scale, 200 * self.scale)];
    messageLabel.numberOfLines = 0;
    messageLabel.text = [NSString stringWithFormat:@"%@\n\n兑换热线：", _exchangePlace];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:messageLabel];
    
    UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(125 * self.scale, 490 * self.scale, 325 * self.scale, 30 * self.scale)];
    [telButton addTarget:self action:@selector(tappedTelButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:telButton];
    
    UILabel *exchangeTelephone = [[UILabel alloc] initWithFrame:CGRectMake(125 * self.scale, 490 * self.scale, 325 * self.scale, 30 * self.scale)];
    exchangeTelephone.text = _exchangeTelephone;
    exchangeTelephone.textColor = ThemeBlue;
    exchangeTelephone.textAlignment = NSTextAlignmentLeft;
    [self addSubview: exchangeTelephone];
}

- (void)tappedTelButton {
    if (_exchangeTelephone.length > 0) {
        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
        //NSLog(@"%@", [NSString stringWithFormat:@"tel://%@", _shopEntity.telephone]);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_exchangeTelephone]]];
        [callPhoneWebVw loadRequest:request];
        
        [self.superview addSubview:callPhoneWebVw];
    }
}




@end
