//
//  FlipsideViewController.h
//  UtilityApplicationSample
//
//  Created by Lion User on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <
    UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) NSString* createdDate;
@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray* savedComments;
@property (strong, nonatomic) NSArray* savedLikes;

- (IBAction)done:(id)sender;
- (void)setTitleName:(NSString*)title;

@end
