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
typedef void(^ResultCallback) (id result);

@interface FBRequester : NSObject

- (void)login: (RequestCallback)callback;
- (void)logout;
- (void)frictionlessLogin: (RequestCallback)callback;
- (BOOL)isSessionOpen;
- (void)requestCurrentUserInfo: (ResultCallback)dataCallback;
- (void)requestRandomFriend: (ResultCallback)dataCallback;
- (void)requestAlbums: (ResultCallback)dataCallback userId:(NSString*)userId;
- (void)requestPhotos: (ResultCallback)dataCallback albumId:(NSString*)albumId;

@end
