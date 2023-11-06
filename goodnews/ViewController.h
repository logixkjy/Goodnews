//
//  ViewController.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 29..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalViewController, ModalPCViewController; 
@interface ViewController : UIViewController  {
    
    UIView *_backView;
    UIView *_menuView;
    
    BOOL isLoadingView;
}
@property (strong, nonatomic) ModalViewController *modalView;
@property (strong, nonatomic) ModalPCViewController *modalPCView;
@property (nonatomic, strong) NSString *str_URL;

- (void)loadMainUrl;
@end
