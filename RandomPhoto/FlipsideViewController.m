//
//  FlipsideViewController.m
//  UtilityApplicationSample
//
//  Created by Lion User on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize detailsLabel;
@synthesize createdDate;
@synthesize delegate = _delegate;
@synthesize savedComments;
@synthesize savedLikes;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    detailsLabel.text = [self getUserFriendlyDate:createdDate];
}

- (NSString*)getUserFriendlyDate: (NSString*) dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-DD'T'hh:mm:ssZZZZ"];
    NSDate *date = [dateFormat dateFromString:dateString];
    [dateFormat setDateFormat:@"MMM d, YYYY"];
    NSString* string = [dateFormat stringFromDate:date];
    return string;
}

- (void)viewDidUnload
{
    [self setDetailsLabel:nil];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Likes";
    } else {
        return @"Comments";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (savedLikes != nil) {
            return savedLikes.count; 
        } else {
            return 0;
        }
    } else {
        if (savedComments != nil) {
            return savedComments.count; 
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LikeCell"];
        }
        FBGraphObject *like = [savedLikes objectAtIndex:indexPath.row];
        cell.textLabel.text = [like objectForKey:@"name"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
        }
        
        FBGraphObject *comment = [savedComments objectAtIndex:indexPath.row];
        NSString* message = [comment objectForKey:@"message"];
        cell.detailTextLabel.text = message;
        FBGraphObject *from = [comment objectForKey:@"from"];
        cell.textLabel.text = [from objectForKey:@"name"];
        return cell;
    }
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)setTitleName:(NSString *)title {
    self.navigationItem.title = title;
}

@end
