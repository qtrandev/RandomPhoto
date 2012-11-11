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
@property (strong, nonatomic) NSMutableDictionary *albumsMap;
@property (strong, nonatomic) NSMutableDictionary *photosMap;
@property (strong, nonatomic) NSString* currentAlbum;
@property int currentPhotoIndex;

//- (NSDictionary<FBGraphUser>*)getUser;
- (NSArray*)getAlbums: (NSString*)userId;
- (void)setAlbums: (NSString*)userId albums:(NSArray*)albums;
- (NSArray*)getPhotos: (NSString*)albumId;
- (void)setPhotos: (NSString*)albumId photos:(NSArray*)photos;

@end
