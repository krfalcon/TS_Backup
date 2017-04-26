//
//  MessageView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/19.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "MessageEntity.h"

@protocol MessageViewDelegate;

@interface MessageView : TempletView
{
    UIScrollView *messageScrollView;
    NSArray*    messageArray;
    
    float        h;
}

@property (strong, nonatomic) id<MessageViewDelegate>     delegate;
@property (assign, nonatomic) BOOL                        ifLatest;

- (void)initMessageView:(NSArray *)array;
- (void)refreshMessageView:(NSArray *)array;

@end

@protocol MessageViewDelegate <NSObject>

- (void)messageViewDidTapMessageButtonWithMessageEntity:(MessageEntity *)messageEntity;
- (void)messageViewDidRefresh;

@end
