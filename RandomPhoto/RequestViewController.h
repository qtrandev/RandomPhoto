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

@interface RequestViewController : UIViewController

- (BOOL)checkLogin:(BOOL)displayLoginWindow;
- (void)showLoadingIndicator:(BOOL)show;
- (void)attemptFrictionlessLogin;
- (void)afterFrictionlessLogin;
- (void)retry;

@end
