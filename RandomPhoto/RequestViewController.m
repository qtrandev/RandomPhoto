//
//  RequestViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestController.h"

@interface RequestViewController ()

@property (strong, nonatomic) RequestController *requestController;

@end

@implementation RequestViewController

@synthesize requestController;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!requestController) {
        requestController = [[RequestController alloc] init];
    }
}

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
    LoginViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dvc1"];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)attemptFrictionlessLogin: (RequestCallback)callback {
    if (![requestController isSessionOpen]) {
        [requestController frictionlesssLogin:callback];
    }
}

- (void)afterFrictionlessLogin {
    // Implemented by subclasses
}

- (void)retry {
    // Implemented by subclasses
}

- (void)showLoadingIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
