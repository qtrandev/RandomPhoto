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
                 NSLog(@"Found: %i friends", friends.count);
                 for (NSDictionary<FBGraphUser>* friend in friends) {
                     //NSLog(@"%@ id %@", friend.name, friend.id);
                 }
                 NSDictionary<FBGraphUser>* friend1 = (NSDictionary<FBGraphUser>*) [friends objectAtIndex:arc4random()%friends.count];
                 
                 [self displayProfileImage:friend1.id];
             }
         }];
    }
}

- (void)displayProfileImage:(NSString *)fId {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", fId];
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
