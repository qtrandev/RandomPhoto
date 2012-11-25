//
//  RequestViewController.m
//  RandomPhoto
//
//  Created by Lion User on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestViewController.h"

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
    [self attemptFrictionlessLogin: ^(void) {
        [self afterFrictionlessLogin];
    }];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
