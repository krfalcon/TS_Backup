//
//  MapViewController.h
//  TSOutlets
//
//  Created by KDC on 3/14/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//
#import "MotherViewController.h"
#import "MapView.h"

#import <UIKit/UIKit.h>

@interface MapViewController : MotherViewController
{
    MapView*    mapview;
}

@property(retain,nonatomic) ShopEntity                          *shopEntity;

@end
