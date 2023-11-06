//
//  ModalViewController.m
//  goodnews
//
//  Created by KimJooYoung on 2015. 4. 30..
//  Copyright (c) 2015년 goodnews. All rights reserved.
//

#import "ModalViewController.h"
#import "AppDelegate.h"
#import <WebKit/WebKit.h>

#import "ModalViewController.h"
#import "ModalPCViewController.h"

@import MessageUI;

@import AVFoundation;
@import AudioToolbox;

@interface ModalViewController () <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *m_statusBarImage;

@property (strong, nonatomic) WKWebView *m_webView;

@property (weak, nonatomic) IBOutlet UIView *m_toolBarView;
@property (weak, nonatomic) IBOutlet UIButton *m_prevButton;
@property (weak, nonatomic) IBOutlet UIButton *m_nextButton;
@property (weak, nonatomic) IBOutlet UIButton *m_moreButton;
@property (weak, nonatomic) IBOutlet UIButton *m_closeButton;


@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GetDataCenter.isShowPUSH_URL = NO;
    
    //이걸 지우면 전화걸때... 꺼짐
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    //백그라운드에서 재생
    AVAudioSession*session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [self setLayout];
    [self loadMainUrl];
    
    isLoadingView = NO;
    
    [self.m_prevButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        if ([self.m_webView canGoBack]) {
            [self.m_webView goBack];
        }
    }];
    
    
    [self.m_nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        if ([self.m_webView canGoForward]) {
            [self.m_webView goForward];
        }
    }];
    
    
    [self.m_moreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        [self.view addSubview:self->_backView];
    }];
    
    
    [self.m_closeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        GetDataCenter.isShowModalView = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    for (id item in [self.m_webView subviews]) {
        if ([item isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)item setBounces:NO];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayout
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.m_statusBarImage.frame = CGRectMake(0, 0, MAIN_SIZE().width, SAFE_AREA_TOP);
        self.m_toolBarView.frame = CGRectMake(0, MAIN_SIZE().height - RESIZE(50), MAIN_SIZE().width, RESIZE(50));
        
        CGFloat gap = (414 - (RESIZE(50) * 6)) / 7;
        
        self.m_prevButton.frame = CGRectMake(gap, 0, RESIZE(50), RESIZE(50));
        self.m_nextButton.frame = CGRectMake(CGRectGetMaxX(self.m_prevButton.frame) + gap, 0, RESIZE(50), RESIZE(50));
        self.m_moreButton.frame = CGRectMake(CGRectGetMaxX(self.m_nextButton.frame) + gap, 0, RESIZE(50), RESIZE(50));
        self.m_closeButton.frame = CGRectMake(MAIN_SIZE().width - RESIZE(50) - gap, 0, RESIZE(50), RESIZE(50));
        
        if (self.m_webView == nil) {
            self.m_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.m_statusBarImage.frame), MAIN_SIZE().width, MAIN_SIZE().height - CGRectGetHeight(self.m_statusBarImage.frame) - CGRectGetHeight(self.m_toolBarView.frame))];
            self.m_webView.UIDelegate = self;
            self.m_webView.navigationDelegate = self;
            self.m_webView.opaque = NO;
        } else {
            self.m_webView.frame = CGRectMake(0, CGRectGetMaxY(self.m_statusBarImage.frame), MAIN_SIZE().width, MAIN_SIZE().height - CGRectGetHeight(self.m_statusBarImage.frame) - CGRectGetHeight(self.m_toolBarView.frame));
        }
        
        [self.view addSubview:self.m_webView];
    } else {
        self.m_statusBarImage.frame = CGRectMake(0, 0, MAIN_SIZE().width, SAFE_AREA_TOP);
        
        self.m_toolBarView.frame = CGRectMake(0, MAIN_SIZE().height - SAFE_AREA_BOTTOM - RESIZE(50), MAIN_SIZE().width, SAFE_AREA_BOTTOM + RESIZE(50));
        
        CGFloat gap = (MAIN_SIZE().width - (RESIZE(50) * 6)) / 7;
        
        self.m_prevButton.frame = CGRectMake(gap, 0, RESIZE(50), RESIZE(50));
        self.m_nextButton.frame = CGRectMake(CGRectGetMaxX(self.m_prevButton.frame) + gap, 0, RESIZE(50), RESIZE(50));
        self.m_moreButton.frame = CGRectMake(CGRectGetMaxX(self.m_nextButton.frame) + gap, 0, RESIZE(50), RESIZE(50));
        self.m_closeButton.frame = CGRectMake(MAIN_SIZE().width - RESIZE(50) - gap, 0, RESIZE(50), RESIZE(50));
        
        self.m_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.m_statusBarImage.frame), MAIN_SIZE().width, MAIN_SIZE().height - CGRectGetHeight(self.m_statusBarImage.frame) - CGRectGetHeight(self.m_toolBarView.frame))];
        self.m_webView.UIDelegate = self;
        self.m_webView.navigationDelegate = self;
        self.m_webView.opaque = NO;
        [self.view addSubview:self.m_webView];
    }
}

- (void)setPopup {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE().width, MAIN_SIZE().height)];
    [_backView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    UIImageView *_img_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE().width, MAIN_SIZE().height)];
    [_img_bg setBackgroundColor:[UIColor blackColor]];
    [_img_bg setAlpha:0.6f];
    [_backView addSubview:_img_bg];
    
    _menuView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *_lbl_copyURL = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE(20), 0, RESIZE(240), RESIZE(44))];
    [_lbl_copyURL setFont:[UIFont boldSystemFontOfSizeDpi:15]];
    [_lbl_copyURL setTextColor:[UIColor blackColor]];
    [_lbl_copyURL setText:@"URL 복사"];
    [_menuView addSubview:_lbl_copyURL];
    
    UIButton *_btn_copyURL = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_copyURL setFrame:CGRectMake(0, 0, RESIZE(260), RESIZE(44))];
    [_btn_copyURL handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backView removeFromSuperview];
            
            // [try catch 구문 정의 실시]
              @try {
                  
                  // [초기 변수 선언 실시]
                  NSString *copyData = GetDataCenter.CURRENT_URL;
                  
                  
                  // [UIPasteboard 사용해 클립보드 복사 수행 실시]
                  [[UIPasteboard generalPasteboard] setString:copyData];
              }
              @catch (NSException *exception) {
                  printf("\n");
                  printf("==================================== \n");
                  printf("[ViewController >> catch :: 예외 상황 확인] \n");
                  printf("[name :: %s] \n", exception.name.description.UTF8String);
                  printf("[reason :: %s] \n", exception.reason.description.UTF8String);
                  printf("==================================== \n");
                  printf("\n");
              }
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:@"클립보드에 저장되었습니다."
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
    [_menuView addSubview:_btn_copyURL];
    
    UIImageView *_img_line_01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, RESIZE(44), RESIZE(260), RESIZE(1))];
    [_img_line_01 setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
    [_menuView addSubview:_img_line_01];
    
    UILabel *_lbl_sendSMS = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE(20), RESIZE(45), RESIZE(240), RESIZE(44))];
    [_lbl_sendSMS setFont:[UIFont boldSystemFontOfSizeDpi:15]];
    [_lbl_sendSMS setTextColor:[UIColor blackColor]];
    [_lbl_sendSMS setText:@"메세지 보내기"];
    [_menuView addSubview:_lbl_sendSMS];
    
    UIButton *_btn_sendSMS = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_sendSMS setFrame:CGRectMake(0, RESIZE(45), RESIZE(260), RESIZE(44))];
    [_btn_sendSMS handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backView removeFromSuperview];
            if (![MFMessageComposeViewController canSendText]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                               message:@"해당기기는 SMS기능이 \n지원되지 않는 기기 입니다."
                                               preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action) {}];

                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }

            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:nil];
            [messageController setBody:GetDataCenter.CURRENT_URL];

            // Present message view controller on screen
            [self presentViewController:messageController animated:YES completion:nil];
        });
    }];
    [_menuView addSubview:_btn_sendSMS];
    
    UIImageView *_img_line_02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, RESIZE(89), RESIZE(260), 1)];
    [_img_line_02 setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
    [_menuView addSubview:_img_line_02];
    
    UILabel *_lbl_sendMail = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE(20), RESIZE(90), RESIZE(240), RESIZE(44))];
    [_lbl_sendMail setFont:[UIFont boldSystemFontOfSizeDpi:15]];
    [_lbl_sendMail setTextColor:[UIColor blackColor]];
    [_lbl_sendMail setText:@"메일 보내기"];
    [_menuView addSubview:_lbl_sendMail];
    
    UIButton *_btn_sendMail = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_sendMail setFrame:CGRectMake(8, RESIZE(90), RESIZE(260), RESIZE(44))];
    [_btn_sendMail handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backView removeFromSuperview];
            if ([MFMailComposeViewController canSendMail]) {
                // 메일을 전송할 수 있는 환경인지 확인.(메일이 설정에서 등록되어 있어야 합니다.)
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                mailController.mailComposeDelegate = self;
                [mailController setToRecipients:nil];
                [mailController setSubject:@""];
                [mailController setMessageBody:GetDataCenter.CURRENT_URL isHTML:NO];     //내용
                [self presentViewController:mailController animated:YES completion:nil]; // Modal의 형태로 창을 띄움니다.
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                               message:@"설정에서 메일을 등록해 주세요."
                                               preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction * action) {}];

                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
    [_menuView addSubview:_btn_sendMail];
    
    UIImageView *_img_cancel_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, RESIZE(134), RESIZE(260), RESIZE(44))];
    [_img_cancel_bg setBackgroundColor:UIColorFromRGB(0x45d7d3)];
    [_menuView addSubview:_img_cancel_bg];
    
    UIButton *_btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_cancel setFrame:CGRectMake(0,RESIZE(134), RESIZE(260), RESIZE(44))];
    [_btn_cancel setBackgroundColor:[UIColor clearColor]];
    [_btn_cancel setTitle:@"취소" forState:UIControlStateNormal];
    [_btn_cancel.titleLabel setFont:[UIFont boldSystemFontOfSizeDpi:15]];
    [_btn_cancel handleControlEvent:UIControlEventTouchUpInside withBlock:^(id  _Nonnull sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backView removeFromSuperview];
        });
    }];
    
    [_menuView addSubview:_btn_cancel];
    
    [_menuView setFrame:CGRectMake(0, 0, RESIZE(260), RESIZE(179))];
    [_menuView setBackgroundColor:[UIColor whiteColor]];
    [_menuView setCenter:CGPointMake(MAIN_SIZE().width/2, MAIN_SIZE().height/2)];
    [_backView addSubview:_menuView];
}

- (void)loadMainUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:GetDataCenter.PUSH_URL]];
        [self.m_webView loadRequest:req];
    });
}

- (IBAction)close {
    GetDataCenter.isShowModalView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// messageComposeViewController delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:@"SMS 전송에 실패하였습니다."
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// mailComposeController delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //상태 결과 값에 따라 처리
    switch (result) {
        case MFMailComposeResultCancelled:  // 취소.
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:@"메일전송이 취소 되었습니다."
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case MFMailComposeResultFailed: // 실패.
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:@"메일전송이 실패했습니다."
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case MFMailComposeResultSent:   //성공.
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"알림"
                                           message:@"메일이 전송되었습니다."
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    // Modal창을 닫습니다.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)scriptControl:(NSString*)strUrl {
    NSRange range = [strUrl rangeOfString:MAIN_KEY];
    
    if (![strUrl hasPrefix:MAIN_KEY]) {
        return YES;
    }
    
    if (range.location != NSNotFound) {
        [GetDataCenter setPUSH_URL:[strUrl stringByReplacingOccurrencesOfString:MAIN_KEY withString:@"http://"]];
        [GetDataCenter setIsShowPUSH_URL:YES];

        [self dismissViewControllerAnimated:YES completion:^{
            ModalViewController *pushUrlView = [self.storyboard instantiateViewControllerWithIdentifier:@"modalView"];
            pushUrlView.modalPresentationStyle = UIModalPresentationFullScreen;
            GetDataCenter.isShowModalView = YES;
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate.window.rootViewController presentViewController:pushUrlView animated:YES completion:nil];
            });
        }];
        return NO;
    }
    
    return YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strUrl = [navigationAction.request.URL absoluteString];
    [GetDataCenter setCURRENT_URL:strUrl];
    NSLog(@"RequestURL[%@]",strUrl);
    
    if ([strUrl containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:SAFARI_OPEN withString:@"http://"]] options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([strUrl hasPrefix:MOVE_KEY]) {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:MOVE_KEY withString:@"http://"]]];
        [self.m_webView loadRequest:req];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([strUrl hasPrefix:SAFARI_OPEN]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[strUrl stringByReplacingOccurrencesOfString:SAFARI_OPEN withString:@"http://"]] options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([strUrl hasPrefix:PCVIEW]) {
        [GetDataCenter setPUSH_URL:[strUrl stringByReplacingOccurrencesOfString:PCVIEW withString:@"http://"]];
        [GetDataCenter setIsShowPUSH_URL:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            ModalPCViewController *modalPCView = [self.storyboard instantiateViewControllerWithIdentifier:@"modalPCView"];
            modalPCView.modalPresentationStyle = UIModalPresentationFullScreen;
            GetDataCenter.isShowModalView = YES;
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate.window.rootViewController presentViewController:modalPCView animated:YES completion:nil];
            });
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([strUrl hasSuffix:@".m3u8"]||
        [strUrl hasSuffix:@".mp4"]||
        [strUrl hasPrefix:@"http://api.soundcloud"]||
        [strUrl hasSuffix:@".mp3"]) {
        isLoadingView = NO;
        AppDelegate *delegate = MAIN_APP_DELEGATE();
        [delegate stopAnimatedLodingView];
    } else {
        isLoadingView = YES;
    }
    
    if (![self scriptControl:strUrl]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if (isLoadingView) {
        AppDelegate *delegate = MAIN_APP_DELEGATE();
        [delegate startAnimatedLodingView];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if (isLoadingView) {
        AppDelegate *delegate = MAIN_APP_DELEGATE();
        [delegate stopAnimatedLodingView];
    }
    webView.scrollView.delegate = self; // set delegate method of UISrollView
    webView.scrollView.maximumZoomScale = 20; // set as you want.
    webView.scrollView.minimumZoomScale = 1; // set as you want.
    
    //// Below two line is for iOS 6, If your app only supported iOS 7 then no need to write this.
    webView.scrollView.zoomScale = 2;
    webView.scrollView.zoomScale = 1;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    NSLog(@"ㅍㅎㅎㅎㅎ");
}

-(void)remoteControlEventNotification:(NSNotification *)note
{
    
}

#pragma mark -
#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.m_webView.scrollView.maximumZoomScale = 20; // set similar to previous.
}

-(BOOL)shouldAutorotate
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}



- (void)deviceDidRotate:(NSNotification *)notification
{
//    self.currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    // Do what you want here
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setLayout];
        });
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
