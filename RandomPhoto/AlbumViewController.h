//
//  AlbumViewController.h
//  RandomPhoto
//
//  Created by Lion User on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"
#import "FriendViewController.h"

@interface AlbumViewController : RequestViewController<
    UITableViewDelegate,
    UITableViewDataSource>

@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;
@property (strong, nonatomic) NSString* currentAlbum;
@property (strong, nonatomic) NSArray* albumsList;

- (IBAction)tagClicked:(id)sender;
- (IBAction)albumClicked:(id)sender;
- (IBAction)randomClicked:(id)sender;
@end
