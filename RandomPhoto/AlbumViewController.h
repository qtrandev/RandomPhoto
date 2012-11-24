//
//  AlbumViewController.h
//  RandomPhoto
//
//  Created by Lion User on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

@interface AlbumViewController : RequestViewController

@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;

@end
