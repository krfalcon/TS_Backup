//
//  ExchangeUrlView.h
//  TSOutlets
//
//  Created by KDC on 3/23/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "TempletView.h"
#import <UIKit/UIKit.h>

#import "ExchangeHistoryEntity.h"
#import "MDIncrementalImageView.h"

@interface ExchangeUrlView : TempletView

- (void)getInfo:(ExchangeHistoryEntity *)ety;

@property (retain, nonatomic) NSString*                      exchangeTelephone;
@property (retain, nonatomic) NSString*                      exchangePlace;


@end
