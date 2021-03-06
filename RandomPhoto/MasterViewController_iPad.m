//
//  MasterViewController_iPad.m
//  RandomPhoto
//
//  Created by Lion User on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController_iPad.h"

@interface MasterViewController_iPad ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSMutableArray* friendList;
- (void)configureView;
@end

@implementation MasterViewController_iPad

@synthesize masterPopoverController = _masterPopoverController;
@synthesize requestController;

- (IBAction)friendButtonClicked:(id)sender {
    FriendViewController_iPad* fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"fvci1"];
    if (self.friendList.count > 0) {
        fvc.currentFriendId = [self.friendList objectAtIndex:arc4random()%self.friendList.count];
    }
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)requestFriends
{
    if (!requestController) {
        requestController = [[RequestController alloc] init];
    }
    [requestController frictionlesssLogin: ^(void) {
        NSLog(@"Requesting to open session.");
        if ([requestController isSessionOpen]) {
            NSLog(@"Session is open.");
            ResultCallback friendsCallback = ^(id friendList) {
                NSMutableArray* friendListArray = (NSMutableArray*)friendList;
                if (friendListArray.count > 0) {
                    NSLog(@"Got %u friends in master view", friendListArray.count);
                    self.friendList = friendListArray;
                } else {
                    NSLog(@"Got nothing in master view");
                }
            };
            [requestController requestFriendList:friendsCallback];
        }
    }];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.clearsSelectionOnViewWillAppear = NO;
        //self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.friendList = [[NSMutableArray alloc] init];
    [self requestFriends];
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (LoginViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //[self initMenu];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = [_objects objectAtIndex:indexPath.row];
        //[[segue destinationViewController] setDetailItem:object];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
