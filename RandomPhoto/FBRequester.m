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
                              //[self requestAlbums:friend.id];
                              NSLog(@"Error: No album photos - not retrying");
                          }
                      }
                      else {
                          NSLog(@"Error getting album photos");
                          //[self showLoadingIndicator:NO];
                      }
                  }
                  ];
                 [connection2 start];
             } else {
                 // Try again with a different friend
                 //self.navigationItem.title = @"No albums found";
                 //[self showLoadingIndicator:NO];
             }
         }
         else {
             NSLog(@"Albums error");
             //[self showLoadingIndicator:NO];
         }
     }
     ];
    [connection start];

}

- (void)requestCurrentUserInfo: (ResultCallback)callback {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             callback(user);
         }
     }];
}

@end
