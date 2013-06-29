//
//  MasterViewController.h
//  RandomPhoto
//
//  Created by Lion User on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestViewController.h"
#import "FriendViewController_iPad.h"

@interface MasterViewController_iPad : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) RequestController *requestController;

@end
