//
//  SetViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotherViewController.h"
#import "SetView.h"

@interface SetViewController : MotherViewController<SetViewDelegate>
{
    SetView*            setView;
    
}

@end
