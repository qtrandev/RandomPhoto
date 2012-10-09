//
//  RandomViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RandomViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RandomViewController ()

@end

@implementation RandomViewController
@synthesize scrollView;
@synthesize imageView;

- (void)requestFriends {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary *result,
           NSError *error) {
             if (!error) {
                 NSArray* friends  = [result objectForKey:@"data"];
                 //NSLog(@"Found: %i friends", friends.count);
                 //for (NSDictionary<FBGraphUser>* friend in friends) {
                     //NSLog(@"%@ id %@", friend.name, friend.id);
                 //}
                 NSDictionary<FBGraphUser>* friend1 = (NSDictionary<FBGraphUser>*) [friends objectAtIndex:arc4random()%friends.count];
                 
                 [scrollView setZoomScale:1.0f]; // reset zoom
                 [self displayProfileImage:friend1.id];
                 self.navigationItem.title = friend1.name;
                 [self requestAlbums:friend1.id];
             }
         }];
    }
}

- (void)displayProfileImage:(NSString *)fId {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fId];
    [self displayImageLink:picLink];
}

- (void)displayImageLink:(NSString *)picLink {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
    [imageView setImage:(image)];
}

- (void)requestRandomPhoto {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary *result,
           NSError *error) {
             if (!error) {
                 NSArray* friends  = [result objectForKey:@"data"];
                 NSDictionary<FBGraphUser>* randomFriend = (NSDictionary<FBGraphUser>*) [friends objectAtIndex:arc4random()%friends.count];
                 
                 [self requestAlbums:randomFriend.id];
             }
         }];
    }
}

- (void)requestAlbums:(NSString *)friendId {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request = [FBRequest
                           requestForGraphPath:
                           [NSString stringWithFormat:@"%@?fields=albums",friendId]];
    [connection addRequest:request completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error && result) {
             id albumResult = [result objectForKey:@"albums"];
             NSArray* albums = [albumResult objectForKey:@"data"];
             NSLog(@"Found: %i albums", albums.count);
             if (albums.count > 0) {
                 FBGraphObject* randomAlbum = (FBGraphObject*) [albums objectAtIndex:arc4random()%albums.count];
                 [self requestAlbumPhotos:[randomAlbum objectForKey:@"id"]];
             } else {
                 // Try again with a different friend
                 [self requestFriends];
             }
         }
         else {
             NSLog(@"Albums error");
         }
     }
     ];
    [connection start];
}

- (void)requestAlbumPhotos:(NSString *)albumId {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request = [FBRequest
                          requestForGraphPath:
                          [NSString stringWithFormat:@"%@?fields=photos",albumId]];
    [connection addRequest:request completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error && result) {
             id photoResult = [result objectForKey:@"photos"];
             NSArray* photos = [photoResult objectForKey:@"data"];
             NSLog(@"Found: %i photos in album", photos.count);
             if (photos.count > 0) {
                 FBGraphObject* randomPhoto = (FBGraphObject*) [photos objectAtIndex:arc4random()%photos.count];
                 NSString* photoLink = [randomPhoto objectForKey:@"source"];
                 [self displayImageLink:photoLink];
                 
             } else {
                 // Try again with a different friend
                 [self requestFriends];
             }
         }
         else {
             NSLog(@"Error getting album photos");
         }
     }
     ];
    [connection start];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self displayProfileImage:@"100248354"];
    [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
    [self requestFriends];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

- (IBAction)goClicked:(id)sender {
    [self requestFriends];
}
@end
