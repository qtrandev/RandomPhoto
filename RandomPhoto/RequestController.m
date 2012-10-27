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
@end

@implementation RequestController

@synthesize requester;

- (id)init
{
    self = [super init];
    if (self) {
        requester = [[FBRequester alloc] init];
    }
    return self;
}

- (void)login {
    [requester login];
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

@end
