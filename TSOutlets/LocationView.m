//
//  LocationView.m
//  TSOutlets
//
//  Created by KDC on 3/11/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "LocationView.h"
#import <MapKit/MapKit.h>

@implementation LocationView

- (void)initView
{
    locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 * self.scale, self.titleHeight + 100, self.frame.size.width - 100 , 300)];
    [locationImageView setImage:[UIImage imageNamed:@"IndexTopImage"]];
    [self addSubview:locationImageView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [locationImageView addGestureRecognizer:pinchGesture];
    
    
    /*拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(panView:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [locationImageView addGestureRecognizer:panGesture];*/
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
    pinView.center = CGPointMake(130, 100);
    
    CGRect endFrame = pinView.frame;
    pinView.frame = CGRectOffset(endFrame, 0, -259);
    [UIView animateWithDuration:0.5
                     animations:^{ pinView.frame = endFrame;}];
    
    [locationImageView addSubview:pinView];
}

- (void) pinchView:(UIPinchGestureRecognizer *) pinchGestureRecognizer
{
    UIView *view = locationImageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

/*
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = locationImageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
*/
@end
