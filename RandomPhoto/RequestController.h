//
//  RequestController.h
//  RandomPhoto
//
//  Created by Lion User on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBRequester.h"

@interface RequestController : NSObject

- (void)login;
- (void)frictionlesssLogin: (RequestCallback)callback;
- (void)logout;
- (BOOL)isSessionOpen;

@end
