//
//  MessagesDelegate.h
//  Telegram P-Edition
//
//  Created by keepcoder on 11.02.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageTableItem;
@protocol MessagesDelegate <NSObject>

@required
-(void)receivedMessage:(MessageTableItem *)message position:(int)position itsSelf:(BOOL)force;
-(void)deleteMessages:(NSArray *)ids;
-(void)flushMessages;
-(void)receivedMessageList:(NSArray *)list inRange:(NSRange)range itsSelf:(BOOL)force;
- (void)didAddIgnoredMessages:(NSArray *)items;

@end
