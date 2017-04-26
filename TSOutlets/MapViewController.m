//
//  MapViewController.m
//  TSOutlets
//
//  Created by KDC on 3/14/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    self.enableGesture = NO;
    
    if (!mapview) {
        mapview = [[MapView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:mapview];
        [mapview setShopEntity:_shopEntity];
        [mapview setFirstFloorUrl:[ArticleCoreDataHelper getF1MapUrl]];
        [mapview setSecondFloorUrl:[ArticleCoreDataHelper getF2MapUrl]];
        
        [mapview getMap];
        
        /*
        [[SingleCase singleCase].coredataOperationQueue addOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [mapview getMapViewWithMapUrl:[ArticleCoreDataHelper getF1MapUrl]];
            }];
        }];*/
        
        self.currentView = mapview;
    }
}
@end
