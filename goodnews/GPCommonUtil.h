//
//  GPCommonUtil.h
//  GoodNewsPodcast
//
//  Created by 김주영 on 2014. 7. 14..
//  Copyright (c) 2014년 GoodNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface GPCommonUtil : NSObject

+ (CGFloat)resize:(CGFloat)size;

+ (CGFloat)getSafaAreaTop;
+ (CGFloat)getSafaAreaBottom;


+ (NSData *_Nullable)sendSynchronousRequest:(NSURLRequest *_Nullable)request returningResponse:(__autoreleasing NSURLResponse *_Nullable*_Nullable)responsePtr error:(__autoreleasing NSError *_Nullable*_Nullable)errorPtr;
+ (void)sendAsynchronousRequest:(NSURLRequest *_Nullable)request completionHandler:(void (^_Nullable)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError))handler;

+ (void) writeIntToDefault:(int) nValue KEY:(NSString *_Nullable)strKey;
+ (int) readIntFromDefault:(NSString *_Nullable)strKey;
+ (void) writeObjectToDefault:(id _Nullable)idValue KEY:(NSString *_Nullable)strKey;
+ (id _Nullable) readObjectFromDefault:(NSString *_Nullable)strKey;
+ (void) writeBoolToDefault:(BOOL)bValue KEY:(NSString *_Nullable)strKey;
+ (BOOL) readBoolFromDefault:(NSString *_Nullable)strKey;
+ (void) writeFloatToDefault:(float) fValue KEY:(NSString *_Nullable)strKey;
+ (float) readFloatFromDefault:(NSString *_Nullable)strKey;

@end

typedef void (^ActionBlock)(id _Nullable sender);

@interface UIButton (Category)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock _Nullable)block;
@end

@interface UIFont (Category)

//MARK: - Font DPI
+ (UIFont *_Nullable)systemFontOfSizeDpi:(CGFloat)size;
+ (UIFont *_Nullable)systemFontOfSizeDpi:(CGFloat)size weight:(UIFontWeight)weight;
+ (UIFont *_Nullable)boldSystemFontOfSizeDpi:(CGFloat)size;

@end
