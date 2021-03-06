//
//  AlbumViewController.m
//  RandomPhoto
//
//  Created by Lion User on 11/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlbumViewController

@synthesize currentFriend;
@synthesize currentAlbum;
@synthesize albumsList;

- (IBAction)tagClicked:(id)sender {
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:currentFriend.id userId:currentFriend.id];
    // Remove jumping back to Albums page
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeObjectAtIndex:navigationArray.count-2];
    self.navigationController.viewControllers = navigationArray;
}

- (IBAction)albumClicked:(id)sender {
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:self.currentAlbum userId:currentFriend.id];
    // Remove jumping back to Albums page
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeObjectAtIndex:navigationArray.count-2];
    self.navigationController.viewControllers = navigationArray;
}

- (IBAction)randomClicked:(id)sender {
    [self selectAlbum:arc4random()%albumsList.count];
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
    [self selectAlbum:indexPath.row];
}

- (void)selectAlbum:(NSInteger)rowId
{
    FBGraphObject *album = [albumsList objectAtIndex:rowId];
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc requestAlbum:[album objectForKey:@"id"] userId:currentFriend.id];
    // Remove jumping back to Albums page
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeObjectAtIndex:navigationArray.count-2];
    self.navigationController.viewControllers = navigationArray;
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
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.50f];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [self.navigationController.view.layer removeAllAnimations];
    [self.navigationController.view.layer addAnimation:animation forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
