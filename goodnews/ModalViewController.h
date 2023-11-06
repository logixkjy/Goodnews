//
//  ModalViewController.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 30..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalViewController, ModalPCViewController; 
@interface ModalViewController : UIViewController {
    
    UIView *_backView;
    UIView *_menuView;
    
    BOOL isLoadingView;
}

@property (strong, nonatomic) ModalViewController *modalView;
@property (strong, nonatomic) ModalPCViewController *modalPCView;

@end
