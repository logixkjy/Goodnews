//
//  ActivityIndicatorCommonViewController.h
//  trueFriend
// 
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ActivityIndicatorCommonViewController : UIViewController {
    UIImageView *_back;
    UIActivityIndicatorView *_indicator;
}

- (void)removeFromSuperViewFadeout;

@end
