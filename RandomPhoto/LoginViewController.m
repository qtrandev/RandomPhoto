//
//  DetailViewController.m
//  RandomPhoto
//
//  Created by Lion User on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) RequestController *requestController;
- (void)configureView;
@end

@implementation LoginViewController

@synthesize requestController = _requestController;
@synthesize button = _button;
@synthesize goButton = _goButton;
@synthesize label = _label;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

- (void)initPanel {
    self.navigationItem.title = @"Getting Started";
    if (FBSession.activeSession.isOpen) {
        [self showLoadingIndicator:YES];
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 [self.label setText: [NSString stringWithFormat:@"Hi %@!", user.name]];
                 [self.button setTitle:@"Logout" forState:UIControlStateNormal];
                 [self.goButton setHidden:NO];
                 [self.detailDescriptionLabel setText:@"You are now ready to get started. Click the Go button to start viewing friends' photos."];
                 self.navigationItem.title = @"Let's Go!";
             }
             [self showLoadingIndicator:NO];
         }];
        
    } else {
        [self.label setText:@"Welcome! Please login."];
        [self.button setTitle:@"Login" forState:UIControlStateNormal];
        [self.goButton setHidden:YES];
        [self.detailDescriptionLabel setText:@"Logging in allows you to access photos of your friends."];
    }
}

- (void)showLoadingIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

#pragma mark - Login/logout

/** Handles both login and logout */
- (void)login:(id)sender {
    if ([self.requestController isSessionOpen]) {
        [self logout];
    } else {
//        NSArray *permissions = [NSArray arrayWithObjects:
//                                @"user_photos",
//                                @"friends_photos",
//                                nil];
//        [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//            // session might now be open.
//            [self initPanel];
//        }];
        [self.requestController login];
    }
}

- (IBAction)goButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logout{
    [self.requestController logout];
    [self initPanel];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
}

#pragma mark - View load/unload

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initPanel];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setButton:nil];
    [self setGoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
