//
//  LKLotteryView.m
//  lottery
//
//  Created by upin on 13-3-6.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "LKLotteryView.h"
#import <QuartzCore/QuartzCore.h>
#import "CAAnimation+EasingEquations.h"

@implementation LKLotteryView

-(id)initWithDialPanel:(UIImage *)panel pointer:(UIImage *)pointer portion:(float) portion
{
    self = [super initWithFrame:CGRectMake(0, 0, panel.size.width * portion, panel.size.height * portion)];
    NSLog(@"我是_p:%f",portion);
    if(self)
    {
        [self setDialPanel:panel pointer:pointer portion:portion ];
    }
    return self;
}
-(void)setDialPanel:(UIImage *)panel pointer:(UIImage *)pointer portion:(float) portion
{
    if(self.dialView == nil)
    {
        _dialView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_dialView];
    }
    _dialView.frame = CGRectMake(0, 0, panel.size.width * portion, panel.size.height * portion);
    _dialView.image = panel;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _dialView.center = center;
    
    if(self.pointerView == nil)
    {
        _pointerView = [[UIImageView alloc]initWithImage:pointer];
        [self addSubview:_pointerView];
    }
    self.pointerView.frame = CGRectMake(0, 0, pointer.size.width, pointer.size.height);
    center.y -=(pointer.size.height/2 - 30);
    _pointerView.center = center;
    
}
-(void)dealloc
{
    self.endEvent = nil;
    self.pointerView = nil;
    self.dialView = nil;
}
-(void)startDuration:(float)duration endAngle:(float)angle
{
    //    float dd = MAX(duration, 8);
    float dd = duration + 3;
    
    float aa = dd * 3 * 2*M_PI + angle / 360 * 2 * M_PI ;
    CALayer* layer = self.dialView.layer;
    
    [layer removeAnimationForKey:@"rotation"];
    CAAnimation* animation = [CAAnimation animationWithKeyPath:@"transform.rotation.z" duration:dd from:[[layer valueForKeyPath:@"transform.rotation.z"] floatValue] to:aa easingFunction:CAAnimationEasingFunctionEaseInOutCubic];
    animation.delegate = self;
    [layer addAnimation:animation forKey:@"rotation"];
    
    [self.dialView.layer setValue:[NSNumber numberWithFloat:angle] forKeyPath:@"transform.rotation.z"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.endEvent != nil)
    {
        float angle =   [[self.dialView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
        self.endEvent(angle);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wheelgamefinished" object:nil];
}
-(void)start
{
    [self startDuration:arc4random()%10+8 endAngle:((arc4random()%100)/100.0)*2*M_PI];
}

@end
