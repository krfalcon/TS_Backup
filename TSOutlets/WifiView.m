//
//  WifiView.m
//  TSOutlets
//
//  Created by KDC on 1/28/16.
//  Copyright © 2016 奚潇川. All rights reserved.
//

#import "WifiView.h"

@implementation WifiView

- (void)initView
{
    wifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.scale, self.titleHeight, self.frame.size.width -5, self.frame.size.height - self.titleHeight)];
    
}

- (void)getWifiInfoWithString:(NSString *)wifiInfo
{
    wifiLabel.text = [NSString stringWithFormat:@"%@\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n ", wifiInfo];
    wifiLabel.numberOfLines = 0;
    wifiLabel.textAlignment = NSTextAlignmentLeft;
    wifiLabel.textColor = ThemeYellow;
    [self addSubview:wifiLabel];
}

@end
