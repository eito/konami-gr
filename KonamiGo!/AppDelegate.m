//
//  AppDelegate.m
//  KonamiGo!
//
//  Created by Eric Ito on 4/5/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "AppDelegate.h"
#import "KONAMIGestureRecognizer.h"

/*
  Turn collector into explorer mode
 */

@interface AppDelegate ()<UIGestureRecognizerDelegate>
{
    KONAMIGestureRecognizer *_konamiGR;
    BOOL _easterEggingIt;
    NSTimer *_easterEggTimer;
}
@end

@implementation AppDelegate

-(void)konami:(id)sender
{
    NSLog(@"recognized gesture");
//    self.window.rootViewController.view.hidden = !self.window.rootViewController.view.hidden;
    _easterEggingIt = !_easterEggingIt;
    if (_easterEggingIt) {
        // begin easter egg
        [self beginEasterEgg];
    }
    else {
        // end easter egg
        [self endEasterEgg];
    }
}

-(void)beginEasterEgg {
    
#ifdef FLASH
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat alpha = self.window.rootViewController.view.alpha;
                         if (alpha == 0.0) {
                             alpha = 1.0;
                         }
                         else {
                             alpha = 0.0;
                         }
                         self.window.rootViewController.view.alpha = alpha;
                     }
                     completion:NULL];
#endif

//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    self.window.rootViewController.view.layer.zPosition = 100;
//    self.window.rootViewController.view.layer.doubleSided = NO;
//    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    transform.m34 = 1.0/800.0;
//    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
//    [animation setDuration:.5];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [animation setFillMode:kCAFillModeForwards];
//    [animation setRemovedOnCompletion:YES];
//    [animation setDelegate:self];
//    [self.window.rootViewController.view.layer addAnimation:animation forKey:@"test"];
    
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.window.rootViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
//                     }
//                     completion:NULL];

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.rootViewController.view.alpha = 0.0;
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.window.rootViewController.view.alpha = 1.0;
                                          } completion:NULL];
                     } completion:^(BOOL finished) {
                         self.window.rootViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
                     }];
    
//    self.window.rootViewController.view.layer.doubleSided = NO;
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         UIView *myView = self.window.rootViewController.view;
//                         CALayer *layer = myView.layer;
//                         CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//                         rotationAndPerspectiveTransform.m34 = 1.0 / -500;
//                         rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, 0.0f, 1.0f, 0.0f);
//                         layer.transform = rotationAndPerspectiveTransform;
//                     }
//                     completion:NULL];
    
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionTransitionFlipFromBottom | UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, -1.0);
//                         [UIView animateWithDuration:0.5
//                                               delay:0.25
//                                             options:UIViewAnimationOptionTransitionFlipFromBottom | UIViewAnimationOptionCurveEaseInOut
//                                          animations:^{
//                                              self.window.rootViewController.view.transform = CGAffineTransformIdentity;
//                                          }
//                                          completion:NULL];
//                     }
//                     completion:NULL];
}

-(void)endEasterEgg {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.rootViewController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL];
}

#pragma mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UIView *mainView = self.window.rootViewController.view;
    _konamiGR = [[KONAMIGestureRecognizer alloc] initWithTarget:self action:@selector(konami:)];
    _konamiGR.delegate = self;
    _konamiGR.cancelsTouchesInView = NO;
    [mainView addGestureRecognizer:_konamiGR];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
