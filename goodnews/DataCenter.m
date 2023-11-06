//
//  DataCenter.m
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 30..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import "DataCenter.h"

static DataCenter* g_DataCenterInstance = nil;
@implementation DataCenter


+ (DataCenter*)shared
{
    if( g_DataCenterInstance == nil )
    {
        @synchronized(self)
        {
            if(g_DataCenterInstance == nil)
            {
                g_DataCenterInstance = [[self alloc] init];
            }
        }
    }
    
    return g_DataCenterInstance;
}

+ (void)terminate
{
    if( g_DataCenterInstance == nil ) return;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        self.isShowPUSH_URL         = NO;
        self.isShowModalView        = NO;
        self.PUSH_URL               = @"";
        self.CURRENT_URL            = @"";
        self.MODAL_URL              = @"";
        self.MAIN_URLstring         = @"";
        self.str_MAIN_URL           = @"";
        
    }
    return self;
}
    

@end
