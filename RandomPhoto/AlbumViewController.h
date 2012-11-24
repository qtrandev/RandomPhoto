//
//  AlbumViewController.h
//  RandomPhoto
//
//  Created by Lion User on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"
#import "FriendViewController.h"

@interface AlbumViewController : RequestViewController

@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;
@property (strong, nonatomic) NSString* currentAlbum;

- (IBAction)tagClicked:(id)sender;
- (IBAction)albumClicked:(id)sender;
@end
