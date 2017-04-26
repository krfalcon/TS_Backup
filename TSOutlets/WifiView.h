//
//  WifiView.h
//  TSOutlets
//
//  Created by KDC on 1/28/16.
//  Copyright © 2016 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"

@interface WifiView : TempletView
{
    UILabel*            wifiLabel;
}

- (void)getWifiInfoWithString:(NSString *)wifiInfo;

@end
