//
//  DataCenter.h
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 30..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GetDataCenter [DataCenter shared]

@interface DataCenter : NSObject

@property (nonatomic)         BOOL isShowPUSH_URL;
@property (nonatomic)         BOOL isShowModalView;

@property (nonatomic, strong) NSString *PUSH_URL;
@property (nonatomic, strong) NSString *MAIN_URLstring;
@property (nonatomic, strong) NSString *str_MAIN_URL;
@property (nonatomic, strong) NSString *CURRENT_URL;
@property (nonatomic, strong) NSString *MODAL_URL;

+ (DataCenter*)shared;
+ (void)terminate;

@end
