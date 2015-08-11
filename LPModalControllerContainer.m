//
//  LPModalControllerContainer.m
//
//  Created by Aliaksandr Huryn on 8/13/14.
//

#import "LPModalControllerContainer.h"

#import "LPModalControllerContainerDelegate.h"

#define LP_ANIMATION_DURATION 0.5

@interface LPModalControllerContainer () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning> {
    UIViewController *_contentController;
    BOOL _presenting;
}

@end

@implementation LPModalControllerContainer

- (id)initWithController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _contentController = controller;
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setupView {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setup {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _presenting = NO;
    return self;
}

#pragma mark - UIViewControllerContextTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return LP_ANIMATION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    if (_presenting) {
		[toVC addChildViewController:_contentController];
        [inView addSubview:toVC.view];
        toVC.view.alpha = 0;
        toVC.view.center = inView.center;

        if ([_contentController conformsToProtocol:@protocol(LPModalControllerContainerDelegate)] && [_contentController respondsToSelector:@selector(animateTransitionToContainer:withDuration:)]) {
            [((id<LPModalControllerContainerDelegate>)_contentController)animateTransitionToContainer:self withDuration:LP_ANIMATION_DURATION];
        } else {
            [toVC.view addSubview:_contentController.view];
            _contentController.view.center = toVC.view.center;
        }

        [UIView animateWithDuration:LP_ANIMATION_DURATION animations:^{
			toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
			[_contentController didMoveToParentViewController:toVC];
        }];
    } else {
		[_contentController willMoveToParentViewController:nil];

        if ([_contentController conformsToProtocol:@protocol(LPModalControllerContainerDelegate)] && [_contentController respondsToSelector:@selector(animateTransitionFromContainer:withDuration:)]) {
            [((id<LPModalControllerContainerDelegate>)_contentController)animateTransitionFromContainer:self withDuration:LP_ANIMATION_DURATION];
        } else {
            [_contentController.view removeFromSuperview];
        }

        [UIView animateWithDuration:LP_ANIMATION_DURATION animations:^{
			fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
			[_contentController removeFromParentViewController];
        }];
    }
}

@end
