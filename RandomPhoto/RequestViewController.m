//
//  RequestViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

@interface RequestViewController ()

@end

@implementation RequestViewController


- (BOOL)checkLogin:(BOOL)displayLoginWindow {
    if (!FBSession.activeSession.isOpen) {
        if (displayLoginWindow) {
            [self displayLoginScreen];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)displayLoginScreen {
    LoginViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dvc1"];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)attemptFrictionlessLogin {
    if (!FBSession.activeSession.isOpen) {
        NSArray *permissions = [NSArray arrayWithObjects:
                                @"user_photos",
                                @"friends_photos",
                                nil];
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            // session might now be open.
            if (!error) {
                [self afterFrictionlessLogin];
            }
        }];
    }
}

- (void)afterFrictionlessLogin {
    // Implemented by subclasses
}

- (void)retry {
    // Implemented by subclasses
}

- (void)showLoadingIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
