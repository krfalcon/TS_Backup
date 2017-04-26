//
//  GameView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/21/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"

@protocol GameViewDelegate;

@interface GameView : TempletView
{
    UIScrollView*                           gameScrollView;
}

@property (weak, nonatomic) id<GameViewDelegate>        delegate;


@end

@protocol GameViewDelegate <NSObject>

- (void)gameViewDidTappedButton:(GameView *)gameView withType:(ViewControllerType) type andParameter:(NSDictionary *)parameter;

@end
