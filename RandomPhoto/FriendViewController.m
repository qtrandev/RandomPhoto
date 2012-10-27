//
//  FriendViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"

@interface FriendViewController () <
    FBFriendPickerDelegate> 
@property (strong, nonatomic) NSDictionary<FBGraphUser>* friend;

@end

@implementation FriendViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize friend;

- (void)initPanel {
    [self displayCurrentUser];
}

- (void)displayCurrentUser {
    [self setTitleBar];
    [self showUserProfileImage];
}

- (void)showUserProfileImage {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", friend.id];
    [self displayImageLink:picLink];
}

- (void)displayImageLink:(NSString *)picLink {
    [self showLoadingIndicator:YES];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
    [self showLoadingIndicator:NO];
    [self resetZoom];
    [imageView setImage:(image)];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (friend == nil) {
        if ([self checkLogin:NO]) {
            [self requestCurrentUser];
        } else {
            [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
        }
    }
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

- (void) requestCurrentUser {
    [self showLoadingIndicator:YES];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             [self showLoadingIndicator:NO];
             friend = user;
             [self initPanel];
         }
         [self showLoadingIndicator:NO];
     }];
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    if (friendPicker.selection.count == 1) {
        friend = [friendPicker.selection objectAtIndex:0];
        [self.navigationController popToViewController:self animated:YES];
        [self displayCurrentUser];
        [self requestFriend];
    }
}

- (IBAction)goClicked:(id)sender {
    [self requestFriend];
}

- (void)requestFriend {
    if ([self checkLogin:YES]) {
        [self showLoadingIndicator:YES];
        [self requestAlbums:friend.id];
        [self setTitleBar];
    }
}

- (void)afterFrictionlessLogin {
    [self requestCurrentUser];
}

- (void)requestAlbums:(NSString *)friendId {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request = [FBRequest
                          requestForGraphPath:
                          [NSString stringWithFormat:@"%@?fields=albums.limit(0)",friendId]];
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
                 self.navigationItem.title = @"No albums found";
                 [self showLoadingIndicator:NO];
             }
         }
         else {
             NSLog(@"Albums error");
             [self showLoadingIndicator:NO];
         }
     }
     ];
    [connection start];
}

- (void)requestAlbumPhotos:(NSString *)albumId {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request = [FBRequest
                          requestForGraphPath:
                          [NSString stringWithFormat:@"%@?fields=photos.limit(0)",albumId]];
    [connection addRequest:request completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error && result) {
             id photoResult = [result objectForKey:@"photos"];
             NSArray* photos = [photoResult objectForKey:@"data"];
             NSLog(@"Found: %i photos in album", photos.count);
             if (photos.count > 0) {
                 FBGraphObject* randomPhoto = (FBGraphObject*) [photos objectAtIndex:arc4random()%photos.count];
                 NSString* photoLink = [randomPhoto objectForKey:@"source"]; // lower res
                 //NSString* photoLink = [[[randomPhoto objectForKey:@"images"]
                 //                        objectAtIndex:0]
                 //                       objectForKey:@"source"];
                 [self displayImageLink:photoLink];
                 [self showLoadingIndicator:NO];
                 
             } else {
                 // Try again
                 self.navigationItem.title = @"No photo found - retrying!";
                 [self requestAlbums:friend.id];
             }
         }
         else {
             NSLog(@"Error getting album photos");
             [self showLoadingIndicator:NO];
         }
     }
     ];
    [connection start];
}


- (IBAction)pickClicked:(id)sender {
    if ([self checkLogin:YES]) {
        [self setTitleBar];
        [self displayFriendPicker];
    }
}

- (void)resetZoom {
    [scrollView setZoomScale:1.0f];
}

- (void)setTitleBar {
    self.navigationItem.title = friend.first_name;
}

@end
