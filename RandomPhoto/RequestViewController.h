//
//  RequestViewController.h
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DetailViewController.h"

@interface RequestViewController : UIViewController

- (BOOL)checkLogin:(BOOL)displayLoginWindow;

@end
