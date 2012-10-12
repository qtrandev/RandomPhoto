//
//  FriendViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
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
    self.navigationItem.title = friend.first_name;
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
    [self showLoadingIndicator:YES];
    if (!FBSession.activeSession.isOpen) {
        NSArray *permissions = [NSArray arrayWithObjects:@"friends_photos", nil];
        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error) {
                // session might now be open.
                [self requestCurrentUser];
            } else {
                [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
            }
        }];
    } else {
        [self requestCurrentUser];
    }
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
        [self.navigationController popViewControllerAnimated:YES];
        [self displayCurrentUser];
    }
}

- (IBAction)goClicked:(id)sender {
    
}

- (IBAction)pickClicked:(id)sender {
    [self displayFriendPicker];
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

@end
