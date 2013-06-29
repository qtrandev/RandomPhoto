//
//  FriendViewController_iPad.m
//  RandomPhoto
//
//  Created by QT on 6/14/13.
//
//

#import "FriendViewController_iPad.h"

@interface FriendViewController_iPad ()

@end

@implementation FriendViewController_iPad

@synthesize scrollView;
@synthesize imageView;
@synthesize currentFriendId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (currentFriendId == nil) currentFriendId = @"220906";
    [self showImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)showImage {
    NSString *picLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", currentFriendId];
    [self displayImageLink:picLink];
}

- (void)displayImageLink:(NSString *)picLink {
    //[self showLoadingIndicator:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picLink]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:(image)];
            //[self resetZoom];
            //[self showLoadingIndicator:NO];
            [scrollView setContentSize:imageView.frame.size];
        });
    });
}

@end
