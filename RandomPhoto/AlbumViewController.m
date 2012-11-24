//
//  AlbumViewController.m
//  RandomPhoto
//
//  Created by Lion User on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"

@implementation AlbumViewController

@synthesize currentFriend;
@synthesize currentAlbum;

- (IBAction)tagClicked:(id)sender {
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:currentFriend.id userId:currentFriend.id];
}

- (IBAction)albumClicked:(id)sender {
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:self.currentAlbum userId:currentFriend.id];
}
@end
