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
@property (strong, nonatomic) IBOutlet UIImageView *likesIcon;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentsIcon;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;
@property (strong, nonatomic) NSString* currentAlbumName;
@property (strong, nonatomic) NSString* createdDate;
@property (strong, nonatomic) NSArray* savedComments;
@property (strong, nonatomic) NSArray* savedLikes;

- (IBAction)goClicked:(id)sender;
- (void)pickClicked:(id)sender;
- (IBAction)previousClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;
- (void)requestTaggedPhotos;
- (void)requestAlbum:(NSString*)albumId userId:(NSString*)userId;

@end
