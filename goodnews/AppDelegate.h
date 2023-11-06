//
//  AppDelegate.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 29..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewController.h"
#import "ViewController.h"
//#import "iVersion.h"

@class ActivityIndicatorCommonViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    ActivityIndicatorCommonViewController *processingController;
    NSString            *str_url;
    NSString            *str_alert;
    NSString            *str_view;
    NSTimer             *_timer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ModalViewController *modalView;

- (void)startAnimatedLodingView;
- (void)stopAnimatedLodingView;

@end
