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
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@end

@implementation RequestController

@synthesize requester;
@synthesize friendPickerController;

- (id)init
{
    self = [super init];
    if (self) {
        requester = [[FBRequester alloc] init];
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

@end
