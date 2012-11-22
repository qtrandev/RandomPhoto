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

@end

@implementation FriendViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize previousButton;
@synthesize nextButton;
@synthesize likesLabel;
@synthesize captionLabel;
@synthesize commentsLabel;
@synthesize currentFriend;

- (void)initPanel {
    [self displayCurrentUser];
    [self displayButtons:NO];
    [self clearTextLabels];
}

- (void)displayButtons: (BOOL)show {
    previousButton.hidden = !show;
    nextButton.hidden = !show;
}

- (void)displayCurrentUser {
    [self clearTextLabels];
    [self displayButtons:NO];
    [self setTitleBar];
    [self showUserProfileImage];
}

- (void)showUserProfileImage {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", currentFriend.id];
    [self displayImageLink:picLink];
}

- (void)displayImageLink:(NSString *)picLink {
    [self showLoadingIndicator:YES];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
    [self resetZoom];
    [imageView setImage:(image)];
    [self showLoadingIndicator:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearTextLabels];
    // Add the Pick button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Pick"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(pickClicked:)];
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
    [self setNextButton:nil];
    [self setPreviousButton:nil];
    [self setLikesLabel:nil];
    [self setCaptionLabel:nil];
    [self setCommentsLabel:nil];
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
        currentFriend = result;
        [self initPanel];
    };
    [self requestCurrentUserInfo:callback];
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    if (friendPicker.selection.count == 1) {
        currentFriend = [friendPicker.selection objectAtIndex:0];
        [self.navigationController popToViewController:self animated:YES];
        [self displayCurrentUser];
        [self requestFriend];
    }
}

- (IBAction)goClicked:(id)sender {
    [self displayButtons:NO];
    [self requestFriend];
}

- (void)requestFriend {
    if ([self checkLogin:YES]) {
        [self showLoadingIndicator:YES];
        [self requestAlbums:currentFriend.id];
        [self setTitleBar];
    }
}

- (void)afterFrictionlessLogin {
    if (currentFriend == nil) {
        [self requestCurrentUser];
    } else {
        [self goClicked:nil];
    }
}

- (void)requestAlbums:(NSString *)friendId {
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self clearTextLabels];
            [self displayPhotoResponse:result];
            [self displayButtons:YES];
        } else {
            self.navigationItem.title = @"No photos";
        }
        [self showLoadingIndicator:NO];
    };
    [self requestRandomPhoto:callback userId:friendId];

}

- (void)pickClicked:(id)sender {
    if ([self checkLogin:YES]) {
        [self setTitleBar];
        [self displayFriendPicker];
    }
}

- (IBAction)previousClicked:(id)sender {
    [self displayButtons:NO];
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self displayPhotoResponse:result];
        } else {
            self.navigationItem.title = @"Previous not found";
        }
        [self displayButtons:YES];
    };
    [self getPreviousPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (IBAction)nextClicked:(id)sender {
    [self displayButtons:NO];
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self displayPhotoResponse:result];
        } else {
            self.navigationItem.title = @"Next not found";
        }
        [self displayButtons:YES];
    };
    [self getNextPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (void)displayPhotoResponse: (id)result{
    FBGraphObject* photo = result;
    NSString* photoLink = [photo objectForKey:@"source"];
    NSString* caption = [photo objectForKey:@"name"];
    FBGraphObject* likes = [photo objectForKey:@"likes"];
    FBGraphObject* comments = [photo objectForKey:@"comments"];
    [self displayImageLink:photoLink];
    if (caption != nil) {
        captionLabel.frame = CGRectMake(10,10,300,100); // Not good when screen size changes.
        [captionLabel setText:caption];
        [captionLabel sizeToFit];
    } else {
        [captionLabel setText:@""];
    }
    if (likes != nil) {
        NSArray* likesList = [likes objectForKey:@"data"];
        [likesLabel setText:[NSString stringWithFormat:@"Likes: %d",likesList.count]];
    } else {
        [likesLabel setText:@""];
    }
    if (comments != nil) {
        NSArray* commentsList = [comments objectForKey:@"data"];
        [commentsLabel setText:[NSString stringWithFormat:@"Comments: %d",commentsList.count]];
    } else {
        [commentsLabel setText:@""];
    }
}

- (void)resetZoom {
    [scrollView setZoomScale:1.0f];
}

- (void)setTitleBar {
    self.navigationItem.title = currentFriend.first_name;
}

- (void)clearTextLabels {
    [likesLabel setText:@""];
    [captionLabel setText:@""];
    [commentsLabel setText:@""];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
