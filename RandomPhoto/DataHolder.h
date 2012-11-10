//
//  DataHolder.h
//  RandomPhoto
//
//  Created by Lion User on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FBGraphUser.h>

@interface DataHolder : NSObject

@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentUser;
@property (strong, nonatomic) NSArray* friends;

- (NSDictionary<FBGraphUser>*)getCurrentUser;

@end
