//
//  ModalPCViewController.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 10. 13..
//  Copyright © 2015년 goodnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalViewController, ModalPCViewController; 
@interface ModalPCViewController : UIViewController {
    
    UIView *_backView;
    UIView *_menuView;
    
    BOOL isLoadingView;
}

@end
