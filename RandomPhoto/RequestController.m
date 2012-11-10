//
//  RequestController.m
//  RandomPhoto
//
//  Created by Lion User on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestController.h"

@interface RequestController()
@property (strong, nonatomic) FBRequester* requester;
@property (strong, nonatomic) DataHolder* data;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@end

@implementation RequestController

@synthesize requester;
@synthesize data;
@synthesize friendPickerController;

- (id)init
{
    self = [super init];
    if (self) {
        requester = [[FBRequester alloc] init];
        data = [[DataHolder alloc] init];
    }
    return self;
}

- (void)login: (RequestCallback)callback {
    [requester login:callback];
}

- (void)frictionlesssLogin: (RequestCallback)callback {
    [requester frictionlessLogin:callback];
}

- (void)logout {
    [requester logout];
}

- (BOOL)isSessionOpen {
    return [requester isSessionOpen];
}


- (void)displayFriendPicker: (id)pickerDelegate navController:(UINavigationController*)navigationController {
    if (!friendPickerController) {
        friendPickerController = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        
        // Set the friend picker delegate
        friendPickerController.delegate = pickerDelegate;
        friendPickerController.title = @"Select friends";
        friendPickerController.allowsMultipleSelection = NO;
    }
    
    [friendPickerController loadData];
    [navigationController pushViewController:self.friendPickerController animated:true];
}

- (void)requestRandomPhoto: (ResultCallback)callback userId:(NSString*)userId {
    [requester requestRandomPhoto:callback userId:userId];
}

- (void)requestCurrentUserInfo: (ResultCallback)callback {
    if (data.currentUser != nil) {
        callback(data.currentUser);
    } else {
        ResultCallback dataCallback = ^(id result) {
            data.currentUser = result;
            callback(result);
        };
        [requester requestCurrentUserInfo:dataCallback];
    }
}

- (void)requestRandomFriend: (ResultCallback)callback {
    if (data.friends != nil) {
        NSDictionary<FBGraphUser>* friend1 = (NSDictionary<FBGraphUser>*) [data.friends objectAtIndex:arc4random()%data.friends.count];
        callback(friend1);
    } else {
        ResultCallback dataCallback = ^(id result) {
            if (result != nil) {
                data.friends = result;
                NSDictionary<FBGraphUser>* friend1 = (NSDictionary<FBGraphUser>*) [data.friends objectAtIndex:arc4random()%data.friends.count];
                callback(friend1);
            } else {
                callback(nil);
            }
        };
        [requester requestRandomFriend:dataCallback];
    }
}

@end
