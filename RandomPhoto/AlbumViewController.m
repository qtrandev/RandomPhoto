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
@synthesize albumsList;

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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (albumsList != nil) {
        return albumsList.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AlbumCell"];
    }
    
    FBGraphObject *album = [albumsList objectAtIndex:indexPath.row];
    NSString* name = [album objectForKey:@"name"];
    cell.textLabel.text = name;
    FBGraphObject *count = [album valueForKey:@"count"];
    NSString* displayText = [NSString stringWithFormat:@"%@ photos", count==nil?@"0":count];
    if ([displayText isEqualToString:@"1 photos"]) {
        displayText = @"1 photo";
    }
    cell.detailTextLabel.text = displayText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FBGraphObject *album = [albumsList objectAtIndex:indexPath.row];
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:[album objectForKey:@"id"] userId:currentFriend.id];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Allow swipe to exit albums view
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftSwipe];
}

-(void)handleLeftSwipe:(UITapGestureRecognizer *)leftSwipe
{
    // Go back to main photos page on swipe
    [UIView animateWithDuration:0.75 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
