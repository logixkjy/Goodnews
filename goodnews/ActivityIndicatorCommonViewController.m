//
//  ActivityIndicatorCommonViewController.m 
// 
//

#import "ActivityIndicatorCommonViewController.h"
@implementation ActivityIndicatorCommonViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    _back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE().width, MAIN_SIZE().height)];
    [_back setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    [_back setBackgroundColor:[UIColor blackColor]];
    [_back setAlpha:0.6f];
    [self.view addSubview:_back];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setFrame:CGRectMake(0, 0, 37, 37)];
    [_indicator setCenter:CGPointMake(MAIN_SIZE().width/2, MAIN_SIZE().height/2)];
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[_indicator stopAnimating];
}

- (void)removeFromSuperViewFadeout
{
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    
    // Make the animatable changes.
    self.view.alpha = 0.0;
    
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
    
    [self.view removeFromSuperview];
}

-(BOOL)shouldAutorotate
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

@end
