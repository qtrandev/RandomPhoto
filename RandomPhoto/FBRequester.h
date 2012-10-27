//
//  FBRequester.h
//  RandomPhoto
//
//  Created by Lion User on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void(^RequestCallback) (void);

@interface FBRequester : NSObject

- (void)login;
- (void)logout;
- (void)frictionlessLogin: (RequestCallback) callback;
- (BOOL)isSessionOpen;

@end
