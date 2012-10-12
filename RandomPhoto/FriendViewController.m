//
//  FriendViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendViewController () {
    NSDictionary<FBGraphUser>* friend;
}
@end

@implementation FriendViewController
@synthesize scrollView;
@synthesize imageView;

- (void)initPanel {
    [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
    [self showUserProfileImage];
}

- (void)showUserProfileImage {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", friend.id];
    [self displayImageLink:picLink];
}

- (void)displayImageLink:(NSString *)picLink {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self login];
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

/** Login if the user hasn't logged in yet */
- (void)login {
    if (!FBSession.activeSession.isOpen) {
        NSArray *permissions = [NSArray arrayWithObjects:@"friends_photos", nil];
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            // session might now be open.
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     friend = user;
                 }
             }];
            [self initPanel];
        }];
    } else {
        [self initPanel];
    }
}

- (IBAction)goClicked:(id)sender {
    
}

- (IBAction)pickClicked:(id)sender {
    
}

@end
