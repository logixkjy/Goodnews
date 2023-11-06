//
//  GPCommonUtil.m
//  GoodNewsPodcast
//
//  Created by 김주영 on 2014. 7. 14..
//  Copyright (c) 2014년 GoodNews. All rights reserved.
//

#import "GPCommonUtil.h"

@implementation GPCommonUtil

#pragma mark -------------------------------------------------------------------
#pragma mark < NSUserDefaults Methods >


+ (CGFloat)resize:(CGFloat)size
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGFloat resize = (414 * size) / 320;
        return resize;
    } else {
        CGFloat resize = (MAIN_SIZE().width * size) / 320;
        return resize;
    }
}

+ (CGFloat)getSafaAreaTop
{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        CGFloat top = window.safeAreaInsets.top;
        return top;
    }
    return 20.f;
}

+ (CGFloat)getSafaAreaBottom
{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        CGFloat bottom = window.safeAreaInsets.bottom;
        return bottom;
    }
    return 0.f;
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responsePtr error:(__autoreleasing NSError **)errorPtr
{
    __block NSData *result = nil;
    
    /// We need to make a session object.
    /// This is key to make this work. This won't work with shared session.
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *sess = [NSURLSession sessionWithConfiguration:conf];
    NSURLSessionTask *task = [sess dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil && data.length > 0) {
            result = data;
        }
        if (errorPtr != NULL) {
            *errorPtr = error;
        }
        if (responsePtr != NULL) {
            *responsePtr = response;
        }
    }];
    [task resume];
    
    while (task.state != NSURLSessionTaskStateCompleted) {
        [NSThread sleepForTimeInterval: 0.1];
    }
    
    return result;
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError))handler
{
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        if (handler) {
            handler(_response, _data, _error);
        }
    }] resume];
}

+ (void) writeIntToDefault:(int) nValue KEY:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
    
	[defaults setInteger:nValue forKey:strKey];
	[defaults synchronize];
}

+ (int) readIntFromDefault:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
    
	return (int)[defaults integerForKey:strKey];
}

+ (void) writeObjectToDefault:(id)idValue KEY:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
	
	[defaults setObject:idValue forKey:strKey];
	[defaults synchronize];
}

+ (id) readObjectFromDefault:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
    
	return [defaults objectForKey:strKey];
}

+ (void) writeBoolToDefault:(BOOL)bValue KEY:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
	
	[defaults setBool:bValue forKey:strKey];
	[defaults synchronize];
}

+(BOOL) readBoolFromDefault:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
    
	return [defaults boolForKey:strKey];
}

+ (void) writeFloatToDefault:(float) fValue KEY:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
	
	[defaults setFloat:fValue forKey:strKey];
	[defaults synchronize];
}

+(float) readFloatFromDefault:(NSString *)strKey
{
	NSUserDefaults *defaults;
	defaults = NUD;
	
	return [defaults floatForKey:strKey];
}
@end


@implementation UIButton (Category)
static char overviewKey;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    
    if (block) {
        block(sender);
    }
}


@end


@implementation UIFont (Category)

//MARK: - Font DPI
+ (UIFont *)systemFontOfSizeDpi:(CGFloat)size
{
    CGFloat retFont = 0;
    retFont = size * MAIN_SIZE().width / 360;
    return [self systemFontOfSize:retFont];
}

+ (UIFont *)systemFontOfSizeDpi:(CGFloat)size weight:(UIFontWeight)weight
{
    CGFloat retFont = 0;
    retFont = size * MAIN_SIZE().width / 360;
    return [self systemFontOfSize:retFont weight:weight];
}

+ (UIFont *)boldSystemFontOfSizeDpi:(CGFloat)size
{
    CGFloat retFont = 0;
    retFont = size * MAIN_SIZE().width / 360;
    return [self boldSystemFontOfSize:retFont];
}

@end
