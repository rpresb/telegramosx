//
//  ChatInfoHeaderView.h
//  Messenger for Telegram
//
//  Created by Dmitry Kondratyev on 3/9/14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "TMView.h"
#import "ChatInfoViewController.h"
#import "ProfileSharedMediaView.h"
#import "UserInfoShortButtonView.h"
#import "TMSharedMediaButton.h"
#import "ChatInfoNotificationView.h"
@class ChatInfoViewController;

@interface LineView : NSView
@end

@interface ChatInfoHeaderView : TMRowView<TMNameTextFieldProtocol>
@property (nonatomic, strong) ChatInfoViewController *controller;
@property (nonatomic) ChatInfoViewControllerType type;
@property (nonatomic, strong) TMSharedMediaButton *sharedMediaButton;
@property (nonatomic,strong) ProfileSharedMediaView *mediaView;
@property (nonatomic, strong) TMNameTextField *nameTextField;


@property (nonatomic, strong,readonly) ChatAvatarImageView *avatarImageView;
@property (nonatomic, strong,readonly) TMHyperlinkTextField *createdByTextField;

@property (nonatomic, strong,readonly) UserInfoShortButtonView *setGroupPhotoButton;
@property (nonatomic, strong,readonly) UserInfoShortButtonView *addMembersButton;

@property (nonatomic, strong,readonly) ChatInfoNotificationView *notificationView;

@property (nonatomic, strong,readonly) LineView *nameLiveView;


- (NSString *)title;
- (void)reload;

@end
