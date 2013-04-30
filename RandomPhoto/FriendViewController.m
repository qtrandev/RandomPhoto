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
@synthesize firstButton;
@synthesize randomButton;
@synthesize likesLabel;
@synthesize likesIcon;
@synthesize captionLabel;
@synthesize commentsLabel;
@synthesize commentsIcon;
@synthesize countLabel;
@synthesize currentFriend;
@synthesize currentAlbumName;
@synthesize createdDate;
@synthesize savedComments;
@synthesize savedLikes;

- (void)initPanel {
    [self displayCurrentUser];
    [self displayButtons:NO];
    [self clearTextLabels];
}

- (void)displayButtons: (BOOL)show {
    int index = [self getCurrentPhotoIndex];
    int count = [self getCurrentPhotoCount];
    previousButton.hidden = !(show && [self shouldDisplayPreviousButton:index count:count]);
    nextButton.hidden = !(show && [self shouldDisplayNextButton:index count:count]);
    firstButton.hidden = !(show && [self shouldDisplayFirstButton:index count:count]);
    randomButton.hidden = !(show && [self shouldDisplayRandomButton:index count:count]);
}

- (BOOL)shouldDisplayPreviousButton: (int)index count:(int)count {
    if (count==1) {
        return NO;
    }
    return YES;
}

- (BOOL)shouldDisplayNextButton: (int)index count:(int)count {
    if (count==1) {
        return NO;
    }
    return YES;
}

- (BOOL)shouldDisplayFirstButton: (int)index count:(int)count {
    if (count<3) {
        return NO;
    } else if (index==0) {
        return NO;
    }
    return YES;
}

- (BOOL)shouldDisplayRandomButton: (int)index count:(int)count {
    if (count<3) {
        return NO;
    }
    return YES;
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:(image)];
            [self resetZoom];
            [self showLoadingIndicator:NO];
        });
    });
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
    [self addGestureRecognizers];
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
    [self setLikesIcon:nil];
    [self setLikesLabel:nil];
    [self setCaptionLabel:nil];
    [self setCommentsLabel:nil];
    [self setCommentsIcon:nil];
    [self setCountLabel:nil];
    [self setFirstButton:nil];
    [self setRandomButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
       
    UIPanGestureRecognizer *panImage = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [imageView addGestureRecognizer:panImage];
}

// TODO - Handle rotation of screen
-(void)panDetected:(UIPanGestureRecognizer *)panImage
{
    CGPoint translation = [panImage translationInView:self.view];
    CGPoint imageViewPosition = imageView.center;
    imageViewPosition.x += translation.x;
    
    imageView.center = imageViewPosition;
    [panImage setTranslation:CGPointZero inView:self.view];
    
    CGPoint velocity = [panImage velocityInView:self.view];
    
    if (panImage.state == UIGestureRecognizerStateEnded)
    {
        // Don't move if change in x is not big enough
        if (abs(imageView.center.x - self.view.center.x) > imageView.bounds.size.width/3)
        {
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 CGPoint c = imageView.center;
                                 if (velocity.x > 0) {
                                     c.x = imageView.bounds.size.width;
                                 }
                                 imageView.center = c;
                             }
                             completion:NULL];
            if (velocity.x > 0)
            {
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^ {
                                     CGPoint c = imageView.center;
                                     c.x += imageView.bounds.size.width;
                                     imageView.center = c;
                                 }
                                 completion:^ (BOOL finished){
                                     [self previousClicked:nil];
                                 }];
            }
            else
            {
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^ {
                                     CGPoint c = imageView.center;
                                     c.x -= imageView.bounds.size.width;
                                     imageView.center = c;
                                 }
                                 completion:^ (BOOL finished){
                                     [self nextClicked:nil];
                                 }];
            }
        } else { // return to original position
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 imageView.center = self.view.center;
                             }
                             completion:NULL];
        }
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap
{
    if (scrollView.zoomScale > 1.0f) {
        [self resetZoom];
    } else {
        float newScale = 2.0f;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleTap locationInView:doubleTap.view]];
        [scrollView zoomToRect:zoomRect animated:YES];
    }
}

-(CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [imageView frame].size.height / scale;
    zoomRect.size.width = [imageView frame].size.width / scale;
    center = [imageView convertPoint:center fromView:self.view];
    zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0));
    return zoomRect;
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
        //[self goClicked:nil];
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

- (void)requestTaggedPhotos {
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
    [self requestTaggedPhotos:callback userId:currentFriend.id];
}

- (void)requestAlbum:(NSString*)albumId userId:(NSString*)userId {
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
    [super requestAlbum:callback albumId:albumId userId:userId];
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
            [self resetZoom];
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
            [self resetZoom];
            self.navigationItem.title = @"Next not found";
        }
        [self displayButtons:YES];
    };
    [self getNextPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (IBAction)randomClicked:(id)sender {
    [self displayButtons:NO];
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self displayPhotoResponse:result];
        } else {
            [self resetZoom];
            self.navigationItem.title = @"No photo found";
        }
        [self displayButtons:YES];
    };
    [self getRandomPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (IBAction)firstClicked:(id)sender {
    [self displayButtons:NO];
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self displayPhotoResponse:result];
        } else {
            [self resetZoom];
            self.navigationItem.title = @"No photo found";
        }
        [self displayButtons:YES];
    };
    [self getFirstPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (void)displayCurrentPhoto {
    [self displayButtons:NO];
    [self showLoadingIndicator:YES];
    ResultCallback callback = ^(id result) {
        if (result != nil) {
            [self displayPhotoResponse:result];
        } else {
            [self resetZoom];
            self.navigationItem.title = @"No photo found";
        }
        [self displayButtons:YES];
    };
    [self getCurrentPhoto:callback];
    [self showLoadingIndicator:NO];
}

- (void)displayPhotoResponse: (id)result{
    FBGraphObject* photo = result;
    NSString* photoLink = [photo objectForKey:@"source"];
    NSString* caption = [photo objectForKey:@"name"];
    createdDate = [photo objectForKey:@"created_time"];
    FBGraphObject* likes = [photo objectForKey:@"likes"];
    FBGraphObject* comments = [photo objectForKey:@"comments"];
    [self displayImageLink:photoLink];
    if (caption != nil) {
        captionLabel.frame =  [self calcCaptionLabelSize];
        [captionLabel setText:caption];
        [captionLabel sizeToFit];
    } else {
        [captionLabel setText:@""];
    }
    if (likes != nil) {
        NSArray* likesList = [likes objectForKey:@"data"];
        [likesLabel setText:[NSString stringWithFormat:@"%d",likesList.count]];
        [likesIcon setHidden:NO];
        savedLikes = likesList;
    } else {
        [likesLabel setText:@""];
        [likesIcon setHidden:YES];
        savedLikes = nil;
    }
    if (comments != nil) {
        NSArray* commentsList = [comments objectForKey:@"data"];
        [commentsLabel setText:[NSString stringWithFormat:@"%d",commentsList.count]];
        [commentsIcon setHidden:NO];
        savedComments = commentsList;
    } else {
        [commentsLabel setText:@""];
        [commentsIcon setHidden:YES];
        savedComments = nil;
    }
    [countLabel setText:[NSString stringWithFormat:@"[%d/%d]",
                         [self getCurrentPhotoIndex]+1,
                         [self getCurrentPhotoCount]]];
}

- (CGRect)calcCaptionLabelSize {
    return CGRectMake(10,10,self.view.frame.size.width-60,100);
}

- (void)resetZoom {
    [scrollView setZoomScale:1.0f];
    imageView.center = scrollView.center;
}

- (void)setTitleBar {
    self.navigationItem.title = currentFriend.first_name;
}

- (void)clearTextLabels {
    [likesLabel setText:@""];
    [likesIcon setHidden:YES];
    [captionLabel setText:@""];
    [commentsLabel setText:@""];
    [commentsIcon setHidden:YES];
    [countLabel setText:@""];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        FlipsideViewController *fvc = [segue destinationViewController];
        [fvc setDelegate:self];
        //[fvc setTitleName:@"Comments"];
        fvc.savedComments = savedComments;
        fvc.savedLikes = savedLikes;
        fvc.createdDate = createdDate;
    }
}

@end
