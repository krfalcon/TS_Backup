//
//  MapView.m
//  TSOutlets
//
//  Created by KDC on 3/14/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>

@implementation MapView

- (void)getMap
{
    
    locationView = [[UIView alloc ] initWithFrame:CGRectMake(0, self.titleHeight * self.frame.size.width / 375.f, self.frame.size.width, self.frame.size.height - self.titleHeight * self.frame.size.width / 375.f)];
    [self addSubview:locationView];
    
    shoplocationView = [[MDIncrementalImageView alloc] initWithFrame:locationView.bounds];
    [shoplocationView setImageUrl:[NSURL URLWithString:[_shopEntity.floor intValue]==1?_firstFloorUrl:_secondFloorUrl]];
    [shoplocationView setIsBlack:NO];
    [shoplocationView setShowLoadingIndicatorWhileLoading:YES];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [locationView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [locationView addGestureRecognizer:panGestureRecognizer];
    
    UIImageView *pinView = [[UIImageView alloc] initWithFrame:CGRectMake(([_shopEntity.coordinateX intValue]/2-15) * self.scale, ([_shopEntity.coordinateY intValue]/2-30) * self.scale, 30 * self.scale, 30 * self.scale)];
    [pinView setImage:[UIImage imageNamed:@"MapPin"]];
    
    CGRect endFrame = pinView.frame;
    pinView.frame = CGRectOffset(endFrame, 0, -259);
    [UIView animateWithDuration:0.5
                     animations:^{ pinView.frame = endFrame;}];
    
    [shoplocationView addSubview:pinView];
    
    [locationView setUserInteractionEnabled:YES];
    [locationView setMultipleTouchEnabled:YES];
    
    [locationView addSubview:shoplocationView];
}

- (void) pinchView:(UIPinchGestureRecognizer*) pinchGestureRecognizer
{
    if ([pinchGestureRecognizer numberOfTouches] < 2) {
        return;
    }
    
    [self adjustAnchorPointForGestureRecognizer:pinchGestureRecognizer];
    
    if ([pinchGestureRecognizer state] == UIGestureRecognizerStateBegan ||[pinchGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        shoplocationView.transform = CGAffineTransformScale(shoplocationView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *) pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView* view = shoplocationView;
        CGPoint locationInView = [pinchGestureRecognizer locationInView:view];
        CGPoint locationInSuperView = [pinchGestureRecognizer locationInView:view.superview];
        
        view.layer.anchorPoint = CGPointMake(locationInView.x / view.bounds.size.width, locationInView.y / view.bounds.size.height);
        view.center = locationInSuperView;
        
    }
}


- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = shoplocationView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end









