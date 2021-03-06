//
//  DialogsHistoryController.m
//  Telegram P-Edition
//
//  Created by keepcoder on 12.02.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "DialogsHistoryController.h"

@implementation DialogsHistoryController


-(id)init {
    if(self = [super init]) {
        self.state = DialogsHistoryStateNeedLocal;
    }
    return self;
}

+(DialogsHistoryController *)sharedController {
    static DialogsHistoryController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[DialogsHistoryController alloc] init];
    });
    return controller;
}

-(void)initialize {
    
}


-(void)next:(int)offset limit:(int)limit callback:(void (^)(NSArray *))callback usersCallback:(void (^)(NSArray *))usersCallback  {
    self.isLoading = YES;
    if(self.state == DialogsHistoryStateNeedLocal) {
        [self loadlocal:offset limit:limit callback:callback];
    } else {
        [self loadremote:offset limit:limit callback:callback];
    }
}

-(void)loadlocal:(int)offset limit:(int)limit callback:(void (^)(NSArray *))callback  {
    [[Storage manager] dialogsWithOffset:offset limit:limit completeHandler:^(NSArray *d, NSArray *m) {
        
        [[DialogsManager sharedManager] add:d];
        [[MessagesManager sharedManager] add:m];
        
        if(d.count < limit) {
            self.state = DialogsHistoryStateNeedRemote;
            
        }
        
         self.isLoading = NO;
        
        if(callback)
            callback(d);
        
       
    }];
}

-(void)loadremote:(int)offset limit:(int)limit callback:(void (^)(NSArray *))callback  {
    NSLog(@"load remote!!! offset %d", offset);
    [RPCRequest sendRequest:[TLAPI_messages_getDialogs createWithOffset:offset max_id:0 limit:limit]successHandler:^(RPCRequest *request, id response) {
        
        TL_messages_dialogs *dialogs = response;
        
        
        [SharedManager proccessGlobalResponse:response];
        
        
        NSMutableArray *converted = [[NSMutableArray alloc] init];
        for (TL_conversation *dialog in [dialogs dialogs]) {
            
            TGMessage *msg = [[MessagesManager sharedManager] find:dialog.top_message];
            
            [converted addObject:[TL_conversation createWithPeer:dialog.peer top_message:dialog.top_message unread_count:dialog.unread_count last_message_date:msg.date notify_settings:dialog.notify_settings last_marked_message:dialog.top_message top_message_fake:dialog.top_message last_marked_date:msg.date]];
            
        }
        
        [[DialogsManager sharedManager] add:converted];
        [[Storage manager] insertDialogs:converted completeHandler:nil];
        
        
        
        if(dialogs.dialogs.count < limit) {
            self.state = DialogsHistoryStateEnd;
        }
        
         self.isLoading = NO;
        
        if(callback)
            callback(converted);
       
        
    } errorHandler:^(RPCRequest *request, RpcError *error) {
        
        self.isLoading = NO;
        
        if(error.error_code == 502) {
            [self loadremote:offset limit:limit callback:callback];
            return;
        }
        
    } timeout:10];

}

-(void)drop {
    self.state = DialogsHistoryStateNeedLocal;
}



@end
