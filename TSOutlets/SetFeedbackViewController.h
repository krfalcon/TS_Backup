//
//  SetFeedbackViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotherViewController.h"
#import "SetFeedbackView.h"
#import "ServiceAPITool.h"

@interface SetFeedbackViewController : MotherViewController <SetFeedbackViewDelegate>
{
    SetFeedbackView*        setFeedbackView;
}

@end
