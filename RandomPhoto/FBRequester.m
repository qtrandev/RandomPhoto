//
//  FBRequester.m
//  RandomPhoto
//
//  Created by Lion User on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBRequester.h"

@implementation FBRequester


- (void)login: (RequestCallback)callback {
    [self frictionlessLogin:callback];
}

- (void)logout {
    if ([self isSessionOpen]) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)frictionlessLogin: (RequestCallback)callback {
    if (![self isSessionOpen]) {
        NSArray *permissions = [NSArray arrayWithObjects:
                                @"user_photos",
                                @"friends_photos",
                                nil];
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            // session might now be open.
            if (!error) {
                callback();
            }
        }];
    }
}

- (BOOL)isSessionOpen {
    return FBSession.activeSession.isOpen;
}

@end
