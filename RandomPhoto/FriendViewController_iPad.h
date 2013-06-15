//
//  FriendViewController_iPad.h
//  RandomPhoto
//
//  Created by QT on 6/14/13.
//
//

#import <UIKit/UIKit.h>

@interface FriendViewController_iPad : UIViewController <
    UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString* currentFriendId;

@end
