//
//  RandomViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RandomViewController.h"

@interface RandomViewController ()

@end

@implementation RandomViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize captionLabel;
@synthesize likesLabel;
@synthesize commentsLabel;
@synthesize currentFriend;

- (void)requestFriends {
    ResultCallback friendsCallback = ^(id friendObj) {
        [self showLoadingIndicator:NO];
        if (friendObj != nil) {
            NSDictionary<FBGraphUser>* friend1 = (NSDictionary<FBGraphUser>*)friendObj;
            [self resetZoom];
            [self displayProfileImage:friend1.id];
            self.navigationItem.title = friend1.name;
            self.currentFriend = friend1;
            ResultCallback callback = ^(id result) {
                [self showLoadingIndicator:NO];
                if (result != nil) {
                    [self displayPhotoResponse:result];
                } else {
                    // Try another random friend
                    [self requestFriends];
                }
            };
            [self showLoadingIndicator:YES];
            [self requestRandomPhoto:callback userId:friend1.id];
        } else {
            self.navigationItem.title = @"Cannot request friends";
        }
    };
    [self requestRandomFriend:friendsCallback];
}

- (void)displayPhotoResponse: (id)result{
    FBGraphObject* photo = result;
    NSString* photoLink = [photo objectForKey:@"source"];
    NSString* caption = [photo objectForKey:@"name"];
    FBGraphObject* likes = [photo objectForKey:@"likes"];
    FBGraphObject* comments = [photo objectForKey:@"comments"];
    [self displayImageLink:photoLink];
    if (caption != nil) {
        [captionLabel setText:caption];
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

- (void)displayProfileImage:(NSString *)fId {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fId];
    [self resetZoom];
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

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if ([self checkLogin:NO]) {
//        [self showLoadingIndicator:YES];
//        [self requestFriends];
//    } else {
//        [self displayImageLink:@"http://cdn1.iconfinder.com/data/icons/Social_store/256/FacebookShop.png"];
//    }
//}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [self setCaptionLabel:nil];
    [self setLikesLabel:nil];
    [self setCommentsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

- (IBAction)goClicked:(id)sender {
    if ([self checkLogin:YES]) {
        [self showLoadingIndicator:YES];
        [self requestFriends];
    }
}

- (IBAction)moreClicked:(id)sender {
    FriendViewController* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvc1"];
    fvc.currentFriend = self.currentFriend;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)afterFrictionlessLogin {
    [self showLoadingIndicator:YES];
    [self requestFriends];
}
@end
