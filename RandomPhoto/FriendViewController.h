//
//  FriendViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

@interface FriendViewController : RequestViewController <
    UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)goClicked:(id)sender;
- (IBAction)pickClicked:(id)sender;

@end
