//
//  MasterViewController.h
//  RandomPhoto
//
//  Created by Lion User on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) LoginViewController *detailViewController;

@end
