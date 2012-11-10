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

- (void)requestRandomPhoto: (ResultCallback)callback userId:(NSString*)userId {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request = [FBRequest
                          requestForGraphPath:
                          [NSString stringWithFormat:@"%@?fields=albums.limit(0)",userId]];
    [connection addRequest:request completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error && result) {
             id albumResult = [result objectForKey:@"albums"];
             NSArray* albums = [albumResult objectForKey:@"data"];
             NSLog(@"Found: %i albums", albums.count);
             if (albums.count > 0) {
                 FBGraphObject* randomAlbum = (FBGraphObject*) [albums objectAtIndex:arc4random()%albums.count];
                 NSString* albumId = [randomAlbum objectForKey:@"id"];
                 [self requestPhoto:callback albumId:albumId userId:userId];
             } else {
                 callback(nil);
             }
         }
         else {
             NSLog(@"Albums error");
             callback(nil);
         }
     }
     ];
    [connection start];

}

- (void)requestPhoto: (ResultCallback)callback albumId:(NSString*)albumId userId:(NSString*)userId {
    FBRequestConnection *connection2 = [[FBRequestConnection alloc] init];
    FBRequest *request2 = [FBRequest
                           requestForGraphPath:
                           [NSString stringWithFormat:@"%@?fields=photos.limit(0)",albumId]];
    [connection2 addRequest:request2 completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error && result) {
             id photoResult = [result objectForKey:@"photos"];
             NSArray* photos = [photoResult objectForKey:@"data"];
             NSLog(@"Found: %i photos in album", photos.count);
             if (photos.count > 0) {
                 FBGraphObject* randomPhoto = (FBGraphObject*) [photos objectAtIndex:arc4random()%photos.count];
                 NSString* photoLink = [randomPhoto objectForKey:@"source"]; // lower res
                 //NSString* photoLink = [[[randomPhoto objectForKey:@"images"]
                 //                        objectAtIndex:0]
                 //                       objectForKey:@"source"];
                 callback(photoLink);
                 
             } else {
                 // Try again
                 //self.navigationItem.title = @"No photo found - retrying!";
                 [self requestRandomPhoto:callback userId:userId];
                 NSLog(@"Error: No album photos - retrying");
             }
         }
         else {
             NSLog(@"Error getting album photos");
             callback(nil);
         }
     }
     ];
    [connection2 start];
}

- (void)requestCurrentUserInfo: (ResultCallback)dataCallback {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             dataCallback(user);
         }
     }];
}

- (void)requestRandomFriend: (ResultCallback)dataCallback {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary *result,
           NSError *error) {
             if (!error) {
                 NSArray* friends  = [result objectForKey:@"data"];
                 dataCallback(friends);
                 //NSLog(@"Found: %i friends", friends.count);
                 //for (NSDictionary<FBGraphUser>* friend in friends) {
                 //NSLog(@"%@ id %@", friend.name, friend.id);
                 //}
             } else {
                 NSLog(@"Error sending request");
                 dataCallback(nil);
             }
         }];
    }
}

@end
