//
//  DataHolder.m
//  RandomPhoto
//
//  Created by Lion User on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataHolder.h"

@interface DataHolder()

@end

@implementation DataHolder

@synthesize currentUser;
@synthesize friends;

- (NSDictionary<FBGraphUser>*)getCurrentUser {
    return currentUser;
}
@end
