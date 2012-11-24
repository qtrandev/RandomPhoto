//
//  RandomViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"
#import "FriendViewController.h"
#import "AlbumViewController.h"

@interface RandomViewController : RequestViewController <
    UIScrollViewDelegate,
    FBFriendPickerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) NSDictionary<FBGraphUser>* currentFriend;

- (IBAction)goClicked:(id)sender;
- (IBAction)moreClicked:(id)sender;
- (IBAction)albumsClicked:(id)sender;
@end
