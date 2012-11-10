//
//  RequestViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "FBRequester.h"
#import "RequestController.h"

@interface RequestViewController : UIViewController

- (BOOL)checkLogin:(BOOL)displayLoginWindow;
- (void)showLoadingIndicator:(BOOL)show;
- (void)attemptFrictionlessLogin: (RequestCallback)callback;
- (void)afterFrictionlessLogin;
- (void)displayFriendPicker;
- (void)requestRandomPhoto: (ResultCallback)callback userId:(NSString*)userId;
- (void)requestCurrentUserInfo: (ResultCallback)callback;
- (void)requestRandomFriend: (ResultCallback)callback;

@end
