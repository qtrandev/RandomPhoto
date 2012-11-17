//
//  RandomViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

@interface RandomViewController : RequestViewController <
    UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;

- (IBAction)goClicked:(id)sender;
@end
