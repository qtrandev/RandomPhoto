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

@synthesize requestController;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!requestController) {
        requestController = [[RequestController alloc] init];
    }
    [self attemptFrictionlessLogin: ^(void) {
        if ([requestController isSessionOpen]) {
            [self afterFrictionlessLogin];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self showLoadingIndicator:NO];
    [super viewDidDisappear:animated];
}

- (BOOL)checkLogin:(BOOL)displayLoginWindow {
    if (![requestController isSessionOpen]) {
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
        NSLog(@"Session is not open on frictionless login - trying to open it");
        [requestController frictionlesssLogin:callback];
    } else {
        callback();
    }
}

- (void)afterFrictionlessLogin {
    // Implemented by subclasses
}

- (void)displayFriendPicker {
    [requestController displayFriendPicker:self navController:self.navigationController];
}

- (void)showLoadingIndicator:(BOOL)show {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)isRequestInProgress {
    return requestController.requestInProgress;
}
- (void)setRequestInProgress: (BOOL)inProgress {
    requestController.requestInProgress = inProgress;
}

- (void)requestRandomPhoto: (ResultCallback)callback userId:(NSString*)userId {
    [requestController requestRandomPhoto:callback userId:userId];
}

- (void)requestTaggedPhotos: (ResultCallback)callback userId:(NSString*)userId {
    [requestController requestTaggedPhotos:callback userId:userId];
}

- (void)requestAlbum:(ResultCallback)callback albumId:(NSString*)albumId userId:(NSString*)userId {
    [requestController requestAlbum:callback albumId:albumId userId:userId];
}

- (void)requestAlbumsList: (ResultCallback)callback userId:userId {
    [requestController requestAlbumsList:callback userId:userId];
}

- (void)requestCurrentUserInfo: (ResultCallback)callback {
    [requestController requestCurrentUserInfo:callback];
}

- (void)requestRandomFriend: (ResultCallback)callback {
    [requestController requestRandomFriend:callback];
}

- (void)getPreviousPhoto: (ResultCallback)callback {
    [requestController getPreviousPhoto:callback];
}

- (void)getNextPhoto: (ResultCallback)callback {
    [requestController getNextPhoto:callback];
}

- (void)getCurrentPhoto: (ResultCallback)callback {
    [requestController getCurrentPhoto:callback];
}

- (void)getFirstPhoto: (ResultCallback)callback {
    [requestController getFirstPhoto:callback];
}

- (void)getRandomPhoto: (ResultCallback)callback {
    [requestController getRandomPhoto:callback];
}

- (int)getCurrentPhotoIndex {
    return [requestController getCurrentPhotoIndex];
}
- (int)getCurrentPhotoCount {
    return [requestController getCurrentPhotoCount];
}

- (NSString*)getCurrentAlbumId {
    return [requestController getCurrentAlbumId];
}
@end
