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

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (friend == nil) {
//        if ([self checkLogin:NO]) {
//            [self requestCurrentUser];
//        } else {
//            [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
//        }
//    }
//}

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
    ResultCallback callback = ^(id result) {
        [self showLoadingIndicator:NO];
        friend = result;
        [self initPanel];
    };
    [self requestCurrentUserInfo:callback];
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
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        [self showLoadingIndicator:NO];
        if (result != nil) {
            [self displayImageLink:result];
        } else {
            self.navigationItem.title = @"No photos";
        }
    };
    [self requestRandomPhoto:callback userId:friendId];

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
