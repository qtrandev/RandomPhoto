//
//  RequestViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

@interface RequestViewController ()

@end

@implementation RequestViewController


- (BOOL)checkLogin:(BOOL)displayLoginWindow {
    if (!FBSession.activeSession.isOpen) {
        if (displayLoginWindow) {
            [self displayLoginScreen];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)displayLoginScreen {
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dvc1"];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
