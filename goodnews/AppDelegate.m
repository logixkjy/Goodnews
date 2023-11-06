//
//  AppDelegate.m
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 29..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivityIndicatorCommonViewController.h"

#import <AFNetworking/AFNetworking.h>
#import "GPCommonUtil.h"

@import UserNotifications;
@import FirebaseCore;
@import FirebaseMessaging;

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:3];
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]
    
    [self resetBadge];
    //    GetDataCenter.MAIN_URLstring = @"";
    //    if (application.applicationState != UIApplicationStateBackground) {
    //        // Track an app open here if we launch with a push, unless
    //        // "content_available" was used to trigger a background push (introduced in iOS 7).
    //        // In that case, we skip tracking here to avoid double counting the app-open.
    //        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
    //        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
    //        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
    ////            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //            if (launchOptions != nil) {
    //                str_url = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"gcm.notification.url"];
    //                str_view = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"gcm.notification.view"];
    //                if (str_url != nil) {
    //                    [GetDataCenter setPUSH_URL:str_url]; // http://kr.mahanaim.org/intro/prvideo.php
    //                    [GetDataCenter setIsShowPUSH_URL:YES];
    //                    if ([str_view isEqualToString:@"modal"]) {
    //                        [self showModalView:self.window.rootViewController];
    //                    } else {
    //                        GetDataCenter.MAIN_URLstring = str_url;
    //                    }
    //                }
    //            }
    //        }
    //    }
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
        }];
    }
    
    [application registerForRemoteNotifications];
    // [END register_for_notifications]
    
    return YES;
}

#pragma mark - APNS.

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // [START_EXCLUDE]
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [self resetBadge];
    str_url = [userInfo objectForKey:@"gcm.notification.url"];
    str_alert = [userInfo[@"aps"] objectForKey:@"alert"][@"body"];
    str_view = [userInfo objectForKey:@"gcm.notification.view"];
    if (str_url != nil) {
        [GetDataCenter setPUSH_URL:str_url]; // http://kr.mahanaim.org/intro/prvideo.php
        [GetDataCenter setIsShowPUSH_URL:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (application.applicationState == UIApplicationStateInactive) {
            if (str_url != nil) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }
        } else if (application.applicationState == UIApplicationStateActive) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:str_alert
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }];

            [alert addAction:defaultAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // [START_EXCLUDE]
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [self resetBadge];
    str_url = [userInfo objectForKey:@"gcm.notification.url"];
    str_alert = [userInfo[@"aps"] objectForKey:@"alert"][@"body"];
    str_view = [userInfo objectForKey:@"gcm.notification.view"];
    if (str_url != nil) {
        [GetDataCenter setPUSH_URL:str_url]; // http://kr.mahanaim.org/intro/prvideo.php
        [GetDataCenter setIsShowPUSH_URL:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (application.applicationState == UIApplicationStateInactive) {
            if (str_url != nil) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }
        } else if (application.applicationState == UIApplicationStateActive) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:str_alert
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }];

            [alert addAction:defaultAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // [START_EXCLUDE]
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [self resetBadge];
    str_url = [userInfo objectForKey:@"gcm.notification.url"];
    str_alert = [userInfo[@"aps"] objectForKey:@"alert"][@"body"];
    str_view = [userInfo objectForKey:@"gcm.notification.view"];
    if (str_url != nil) {
        [GetDataCenter setPUSH_URL:str_url]; // http://kr.mahanaim.org/intro/prvideo.php
        [GetDataCenter setIsShowPUSH_URL:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            if (str_url != nil) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }
        } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:str_alert
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }];

            [alert addAction:defaultAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [self resetBadge];
    str_url = [userInfo objectForKey:@"gcm.notification.url"];
    str_alert = [userInfo[@"aps"] objectForKey:@"alert"][@"body"];
    str_view = [userInfo objectForKey:@"gcm.notification.view"];
    if (str_url != nil) {
        [GetDataCenter setPUSH_URL:str_url]; // http://kr.mahanaim.org/intro/prvideo.php
        [GetDataCenter setIsShowPUSH_URL:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            if (str_url != nil) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }
        } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:str_alert
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
                if ([str_view isEqualToString:@"modal"]) {
                    [self showModalView:self.window.rootViewController];
                } else {
                    [self moveUrl];
                }
            }];

            [alert addAction:defaultAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
    
    completionHandler();
}

// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    [[FIRMessaging messaging] subscribeToTopic:@"/topics/ios" completion:^(NSError * _Nullable error) {
        
    }];
    
    NSLog(@"Connected to FCM. [%@]",fcmToken);
    if (![GPCommonUtil readBoolFromDefault:@"isRegisterDevice"]) {
        [self sendRegisterDevice:fcmToken];
    }
}
// [END refresh_token]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs device token here.
    // [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)sendRegisterDevice:(NSString*)fcmToken
{
    NSDictionary *param = @{@"deviceToken":fcmToken,
                            @"deviceType":@"ios",
                            @"appIdentifier":@"com.gnn.GoodNews",
                            @"appName":@"기쁜소식",
                            @"appVersion":[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
                            @"phone":@"",
                            @"timezone":[[NSTimeZone localTimeZone] name]};
    
    NSMutableString *body = [NSMutableString string];
    for (NSString *key in param.allKeys) {
        [body appendString:body.length == 0 ?@"":@"&"];
        [body appendString:key];
        [body appendString:@"="];
        [body appendString:param[key]];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.goodnews.or.kr/adm/notification/registerDevice"]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    NSError *error = nil;
    NSData *data = [GPCommonUtil sendSynchronousRequest:request returningResponse:nil error:&error];
//    NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"error: %@",error);

    if (error == nil && data.length) {
        [GPCommonUtil writeBoolToDefault:YES KEY:@"isRegisterDevice"];
    }
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    //    [manager POST:@"http://neo.goodnews.or.kr/adm/notification/registerDevice" parameters:param progress:nil
    //          success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
    //              NSLog(@"Response: %@", responseObject);
    //          } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
    //              NSLog(@"Error: %@", error);
    //          }];
}

-(void)resetBadge {
    //Badge 개수 초기화
    NSLog(@"badgeCount => %ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void) showModalView:(id)target{
    
    if (!GetDataCenter.isShowModalView) {
        self.modalView = nil;
        ModalViewController *pushUrlView = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"modalView"];
        pushUrlView.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalView = pushUrlView;
        
        GetDataCenter.isShowModalView = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [target presentViewController:self.modalView animated:YES completion:nil];
        });
    }
    
    return;
}

- (void)moveUrl {
    dispatch_async(dispatch_get_main_queue(), ^{
        GetDataCenter.MAIN_URLstring = str_url;
        [((ViewController*)self.window.rootViewController) loadMainUrl];
    });
}

//- (BOOL)iVersionShouldDisplayNewVersion:(NSString *)version details:(NSString *)versionDetails{
//    NSLog(@"%@",version);
//    NSLog(@"%@",versionDetails);
//    [[[UIAlertView alloc] initWithTitle:@"업데이트" message:@"업데이트된 버전이 스토어에 등록되었습니다.\n지금 업데이트 하시겠습니까?" delegate:self cancelButtonTitle:@"업데이트" otherButtonTitles:@"나중에하기", nil] show];
//
//    return NO;
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id515881424"] options:@{} completionHandler:nil];
//    }
//}

#pragma mark -
#pragma mark Animation View part

- (void)startAnimatedLodingView
{
    if (processingController == nil) {
        processingController = [[ActivityIndicatorCommonViewController alloc] initWithNibName:nil bundle:nil];
        [self.window addSubview:processingController.view];
    }
    [self.window bringSubviewToFront:processingController.view];
    NSLog(@"startAnimatedLodingView");
    _timer = [NSTimer scheduledTimerWithTimeInterval: 30.0f
                                              target: self
                                            selector: @selector(stopAnimatedLodingView)
                                            userInfo: nil
                                             repeats: NO];
}

- (void)stopAnimatedLodingView
{
    [_timer invalidate];
    if (processingController) {
        [processingController removeFromSuperViewFadeout];
        processingController = nil;
    }
    NSLog(@"stopAnimatedLodingView");
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
