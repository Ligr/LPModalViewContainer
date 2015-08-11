//
//  LPModalControllerContainerDelegate.h
//
//  Created by Aliaksandr Huryn on 8/13/14.
//

#import <Foundation/Foundation.h>

@protocol LPModalControllerContainerDelegate <NSObject>

@optional
- (void)animateTransitionToContainer:(UIViewController *)container withDuration:(CGFloat)duration;
- (void)animateTransitionFromContainer:(UIViewController *)container withDuration:(CGFloat)duration;

@end
