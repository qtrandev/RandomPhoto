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

- (void)requestTaggedPhotos: (ResultCallback)callback userId:(NSString*)userId {
    [self requestRandomPhoto2:callback albumId:userId];
}

- (void)requestAlbum:(ResultCallback)callback albumId:(NSString*)albumId userId:(NSString*)userId {
    [self requestRandomPhoto2:callback albumId:albumId];
    // Not sure what to do with userId yet.
    // Might want to somehow cache future albums.
}

- (void)requestAlbumsList: (ResultCallback)callback userId:userId {
    NSArray* albums = [data getAlbums:userId];
    if (albums != nil) {
        if (albums.count > 0){
            callback(albums);
        } else {
            callback(nil);
        }

    } else {
        ResultCallback dataCallback = ^(id result) {
            if (result != nil) {
                NSArray* myAlbums = result;
                [data setAlbums:userId albums:myAlbums];
                if (myAlbums.count > 0) {
                    callback(myAlbums);
                } else {
                    callback(nil);
                }
            } else {
                callback(nil);
            }
        };
        [requester requestAlbums:dataCallback userId:userId];
    }
}

- (void)requestRandomPhoto: (ResultCallback)callback userId:(NSString*)userId {
    NSArray* albums = [data getAlbums:userId];
    if (albums != nil) {
        if (albums.count > 0) {
            [self handleAlbums:callback albums:albums userId:userId];
        } else {
            callback(nil);
        }
    } else {
        ResultCallback dataCallback = ^(id result) {
            if (result != nil) {
                NSArray* myAlbums = result;
                [data setAlbums:userId albums:myAlbums];
                if (myAlbums.count > 0) {
                    [self handleAlbums:callback albums:myAlbums userId:userId];
                } else {
                    callback(nil); // Never seems to be called
                }
            } else {
                callback(nil); // This gets called if no albums
            }
        };
        [requester requestAlbums:dataCallback userId:userId];
    }
}

- (void)handleAlbums: (ResultCallback)callback albums:(NSArray*)albums userId:(NSString*)userId {
    FBGraphObject* randomAlbum = (FBGraphObject*) [albums objectAtIndex:arc4random()%albums.count];
    NSString* albumId = [randomAlbum objectForKey:@"id"];
    ResultCallback photoCallback = ^(id result) {
        if (result != nil) {
            callback(result); // photoLink
        } else {
            if (albums.count > 1) {
                NSLog(@"Error: No album photos - retrying");
                [self requestRandomPhoto:callback userId:userId];
            } else {
                callback(nil); // User has no photos
            }
        }
    };
    [self requestRandomPhoto2:photoCallback albumId:albumId];
}

- (void)requestRandomPhoto2: (ResultCallback)callback albumId:(NSString*)albumId {
    NSArray* photos = [data.photosMap objectForKey:albumId];
    if (photos != nil) {
        if (photos.count > 0) {
            data.currentAlbum = albumId;
            [self handlePhotos:callback photos:photos];
        } else {
            callback(nil);
        }
    } else {
        ResultCallback dataCallback = ^(id result) {
            if (result != nil) {
                NSArray* myPhotos = result;
                [data setPhotos:albumId photos:myPhotos];
                if (myPhotos.count > 0) {
                    data.currentAlbum = albumId;
                    [self handlePhotos:callback photos:myPhotos];
                } else {
                    callback(nil);
                }
            } else {
                NSLog(@"Photo callback is nil");
                callback(nil);
            }
        };
        [requester requestPhotos:dataCallback albumId:albumId];
    }
}

- (void)handlePhotos: (ResultCallback)callback photos:(NSArray*)photos {
    int randIndex = arc4random()%photos.count;
    FBGraphObject* randomPhoto = (FBGraphObject*) [photos objectAtIndex:randIndex];
    //NSString* photoLink = [randomPhoto objectForKey:@"source"]; // lower res
    //NSString* photoLink = [[[randomPhoto objectForKey:@"images"]
    //                        objectAtIndex:0]
    //                       objectForKey:@"source"];
    data.currentPhotoIndex = randIndex;
    callback(randomPhoto);
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

- (void)getPreviousPhoto: (ResultCallback)callback {
    [self getPhotoPosition:callback step:-1];
}

- (void)getNextPhoto: (ResultCallback)callback {
    [self getPhotoPosition:callback step:1];
}

- (void)getCurrentPhoto: (ResultCallback)callback {
    [self getPhotoPosition:callback step:0];
}

- (void)getPhotoPosition: (ResultCallback)callback step:(int)step {
    NSArray* currentAlbumPhotos = [data.photosMap objectForKey:data.currentAlbum];
    if (currentAlbumPhotos.count > 1) {
        int newIndex = data.currentPhotoIndex+step;
        if (newIndex < 0) {
            newIndex = currentAlbumPhotos.count + newIndex;
        }
        if (newIndex >= currentAlbumPhotos.count) {
            newIndex = newIndex - currentAlbumPhotos.count;
        }
        FBGraphObject* randomPhoto = (FBGraphObject*) [currentAlbumPhotos objectAtIndex:newIndex];
        data.currentPhotoIndex = newIndex;
        callback(randomPhoto);
    } else {
        callback(nil);
    }
}

- (int)getCurrentPhotoIndex {
    return data.currentPhotoIndex;
}
- (int)getCurrentPhotoCount {
    NSArray* currentAlbumPhotos = [data.photosMap objectForKey:data.currentAlbum];
    return currentAlbumPhotos.count;
}

- (NSString*)getCurrentAlbumId {
    return data.currentAlbum;
}

@end
