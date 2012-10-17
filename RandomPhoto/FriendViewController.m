//
//  FriendViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import "DetailViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendViewController () <
    FBFriendPickerDelegate> 
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSDictionary<FBGraphUser>* friend;

@end

@implementation FriendViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize friendPickerController = _friendPickerController;
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

- (void)showLoadingIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

- (void) requestCurrentUser {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             [self showLoadingIndicator:NO];
             friend = user;
             [self initPanel];
         }
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

- (BOOL)checkLogin:(BOOL)displayLoginWindow {
    if (!FBSession.activeSession.isOpen) {
        if (displayLoginWindow) {
            [self displayLoginScreen];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)displayLoginScreen {
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dvc1"];
    [self.navigationController pushViewController:dvc animated:YES];
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

- (void)displayFriendPicker {
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        
        // Set the friend picker delegate
        self.friendPickerController.delegate = self;
        self.friendPickerController.title = @"Select friends";
        self.friendPickerController.allowsMultipleSelection = NO;
    }
    
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController animated:true];
}

- (void)resetZoom {
    [scrollView setZoomScale:1.0f];
}

- (void)setTitleBar {
    self.navigationItem.title = friend.first_name;
}

@end
