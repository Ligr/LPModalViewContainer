# LPModalViewContainer
Make it easier to present modal dialogs with posibility to add custom animations.

## How to use
```Objective-C
UIViewController *childController = [[MyChildViewController alloc] init];
UIViewController *mcc = [[LPModalControllerContainer alloc] initWithController:childController];
[self presentViewController:mcc animated:YES completion:nil];
```

## Custom animation
In order to use custom animation `MyChildViewController` should implement protocol `LPModalControllerContainerDelegate`. Here is how to add slide from the bottom animation:
```Objective-C
- (void)animateTransitionToContainer:(UIViewController *)container withDuration:(CGFloat)duration {
  // set final location
	CGRect frame = container.view.bounds;
	frame.origin.y = frame.size.height - self.view.frame.size.height;
	frame.size.height = self.view.frame.size.height;
	self.view.frame = frame;
	// hide view
	self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
	[container.view addSubview:self.view];
	// animate view appearance
	[UIView animateWithDuration:duration animations:^{
		self.view.transform = CGAffineTransformIdentity;
	}];
}
```
