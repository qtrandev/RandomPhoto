//
//  FlipSegue.m
//  RandomPhoto
//
//  Created by QT on 4/3/13.
//
//

#import "FlipSegue.h"

@implementation FlipSegue

-(void)perform {
    UIInterfaceOrientation orientation = [self.sourceViewController interfaceOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        UIViewController *src = (UIViewController*) self.sourceViewController;
        UIViewController *dst = (UIViewController*) self.destinationViewController;
//        [UIView transitionFromView:src.navigationController.view toView:dst.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
//            [src.navigationController presentModalViewController:dst animated:NO];
//        }];
        [UIView transitionWithView:src.navigationController.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            //[src.navigationController presentModalViewController:dst animated:NO];
        }completion:^(BOOL complete){
            [src.navigationController presentModalViewController:dst animated:NO];
        }];
    } else {
        UIViewController *src = (UIViewController*) self.sourceViewController;
        UIViewController *dst = (UIViewController*) self.destinationViewController;
        [UIView transitionFromView:src.navigationController.view toView:dst.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished){
            [src.navigationController presentModalViewController:dst animated:NO];
        }];
    }
}

@end
