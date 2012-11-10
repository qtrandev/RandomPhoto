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
@synthesize albumsMap;
@synthesize photosMap;

- (id)init
{
    self = [super init];
    if (self) {
        albumsMap = [[NSMutableDictionary alloc] init ];
        photosMap = [[NSMutableDictionary alloc] init ];
    }
    return self;
}

- (NSArray*)getAlbums: (NSString*)userId {
    return [albumsMap objectForKey:userId];
}

- (void)setAlbums: (NSString*)userId albums:(NSArray*)albums {
    [albumsMap setObject:albums forKey:userId];
}

- (NSArray*)getPhotos: (NSString*)albumId {
    return [photosMap objectForKey:albumId];
}

- (void)setPhotos: (NSString*)albumId photos:(NSArray*)photos {
    [photosMap setObject:photos forKey:albumId];
}

@end
