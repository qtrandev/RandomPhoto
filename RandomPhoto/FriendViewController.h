//
//  FriendViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"
#import "FlipsideViewController.h"

@interface FriendViewController : RequestViewController <
    UIScrollViewDelegate,
    FlipsideViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;
@property (strong, nonatomic) NSArray* savedComments;
@property (strong, nonatomic) NSArray* savedLikes;

- (IBAction)goClicked:(id)sender;
- (void)pickClicked:(id)sender;
- (IBAction)previousClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;

@end
