//
//  MapView.h
//  TSOutlets
//
//  Created by KDC on 3/14/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"
#import "MDIncrementalImageView.h"

#import "ShopEntity.h"

@interface MapView : TempletView
{
    UIView*                     locationView;
    MDIncrementalImageView*     shoplocationView;
    
}

- (void)getMap;

@property (retain, nonatomic) NSString                    *firstFloorUrl;
@property (retain, nonatomic) NSString                    *secondFloorUrl;
@property(retain,nonatomic) ShopEntity                    *shopEntity;


@end
