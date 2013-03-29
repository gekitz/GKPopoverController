//
//  GFPopoverController.m
//  Gastrofix
//
//  Created by Georg Kitz on 2/19/13.
//	Copyright (C) 2013, Georg Kitz, @gekitz
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to do
//	so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

#import "GKPopoverController.h"
#import "GIKPopoverBackgroundView.h"

#import "GKPopoverAttributes.h"

#import <QuartzCore/QuartzCore.h>

@interface GKPopoverController () <UIGestureRecognizerDelegate>{
	struct{
		unsigned int shouldDismiss:1;
		unsigned int didDismiss:1;
	}_delegateFlags;
}
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) GIKPopoverBackgroundView *popoverBackgroundView;

@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, assign) BOOL popoverVisible;
@end

@implementation GKPopoverController

#pragma mark -
#pragma mark Properties

- (GKPopoverAttributes *)popoverAttributes
{
	if (_popoverAttributes == nil) {
		_popoverAttributes = [GKPopoverAttributes defaultAttributes];
	}
	
	return _popoverAttributes;
}

- (void)setDelegate:(id<GKPopoverControllerDelegate>)delegate
{
	_delegate = delegate;
	_delegateFlags.shouldDismiss = [_delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)];
	_delegateFlags.didDismiss = [_delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)];
}

#pragma mark -
#pragma mark Delegate Wrapper Methods

- (BOOL)_delegateShouldDismissPopover
{
	if (_delegateFlags.shouldDismiss) {
		return (BOOL)[_delegate performSelector:@selector(popoverControllerDidDismissPopover:) withObject:self];
	}
	
	return YES;
}

- (void)_delegateDidDismiss
{
	if (_delegateFlags.didDismiss) {
		[_delegate performSelector:@selector(popoverControllerDidDismissPopover:) withObject:self];
	}
}

#pragma mark -
#pragma mark Private Methods

- (CGRect)_rectInTopViewForRect:(CGRect)rect inView:(UIView *)view
{
	UIView *superview = [[[UIApplication sharedApplication] delegate] window];
	return [view convertRect:rect toView:superview];
}

- (CGFloat)_arrowOffsetForRect:(CGRect)rect inView:(UIView *)view
{
	CGRect rectInSuperView = [self _rectInTopViewForRect:rect inView:view];
	return CGRectGetMidX(rectInSuperView) - CGRectGetWidth(self.view.frame) / 2;
}

- (CGRect)_rectForPopoverBackgroundViewWithRect:(CGRect)rect inView:(UIView *)view arrowDirection:(UIPopoverArrowDirection)arrowDirection
{
	//calculate popover bounds
	CGSize contentSizeForViewInPopover = self.contentViewController.contentSizeForViewInPopover;
	
	UIEdgeInsets popoverEdgeInsets = self.popoverAttributes.popoverEdgeInsets;
	CGFloat totalWidth = contentSizeForViewInPopover.width + popoverEdgeInsets.left + popoverEdgeInsets.right;
	CGFloat totalHeight = contentSizeForViewInPopover.height + popoverEdgeInsets.top + popoverEdgeInsets.bottom + self.popoverAttributes.popoverArrowHeight;
	
	CGFloat xOffset = CGRectGetWidth(self.view.frame) / 2 - totalWidth / 2;
	CGRect transformendRect = [self _rectInTopViewForRect:rect inView:view];
	
	
	// calculate the y-offset of the popover view
	CGRect popoverRect = CGRectZero;
	if (arrowDirection == UIPopoverArrowDirectionUp) {
		popoverRect = CGRectMake(xOffset, CGRectGetMaxY(transformendRect), totalWidth, totalHeight);
	} else if (arrowDirection == UIPopoverArrowDirectionDown){
		
		CGFloat yOffset = CGRectGetMinY(transformendRect) - totalHeight;
		popoverRect = CGRectMake(xOffset, yOffset, totalWidth, totalHeight);
	}
	
	// align the popover so that the arrow is centered to the view it should be attached to
	// this could happen if the popover is quite small and the the view it should be added to is
	// left or right on the outside
	if ((CGRectGetMaxX(popoverRect) - self.popoverAttributes.popoverArrowWidth / 2) < CGRectGetMidX(transformendRect)) {
		
		CGFloat difference = CGRectGetMidX(transformendRect) + self.popoverAttributes.popoverArrowWidth / 2 - CGRectGetMaxX(popoverRect);
		popoverRect.origin.x += difference;
	
	} else if(CGRectGetMidX(transformendRect) < CGRectGetMinX(popoverRect) + self.popoverAttributes.popoverArrowWidth / 2){
		popoverRect.origin.x = CGRectGetMidX(transformendRect) - self.popoverAttributes.popoverArrowWidth / 2;
	}
	
	return popoverRect;
}

- (NSInteger)_indexForBarButtonItem:(UIBarButtonItem *)item barButtonParent:(UIView *)barButtonParent
{
	if ([barButtonParent isKindOfClass:[UINavigationBar class]]) {
		
		return [self _indexForBarButtonItem:item inNavigationBar:(UINavigationBar *)barButtonParent];
	} else {
		
		return [self _indexForBarButtonItem:item inToolBar:(UIToolbar *)barButtonParent];
	}
}

- (NSInteger)_indexForBarButtonItem:(UIBarButtonItem *)item inNavigationBar:(UINavigationBar *)navigationBar
{
	UINavigationItem *navigationItem = [navigationBar.items lastObject];
	
	NSMutableArray *items = [NSMutableArray arrayWithArray:navigationItem.leftBarButtonItems];
	[items addObjectsFromArray:navigationItem.rightBarButtonItems];
	
	return [items indexOfObject:item];
}

- (NSInteger)_indexForBarButtonItem:(UIBarButtonItem *)item inToolBar:(UIToolbar *)toolbar
{
	return [toolbar.items indexOfObject:item];
}

- (void)_placeDropShadow
{
    CGRect bounds = self.contentViewController.view.superview.bounds;
	
	//setup black shadowlayer
	CALayer *shadowLayer = [CALayer layer];
	shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
	shadowLayer.frame = bounds;
	shadowLayer.cornerRadius = 7.0f;
	
	
	//setup shadow mask layer
	CAShapeLayer* shadowMaskLayer = [CAShapeLayer layer];
	[shadowMaskLayer setFrame:bounds];
	
	//shadow stuff
	[shadowMaskLayer setShadowColor:[[UIColor colorWithWhite:0 alpha:1] CGColor]];
	[shadowMaskLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
	[shadowMaskLayer setShadowOpacity:1.0f];
	[shadowMaskLayer setShadowRadius:5];
	
	//causes the inner region in this example to !!NOT!! be filled.
	[shadowMaskLayer setFillRule:kCAFillRuleEvenOdd];
	
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectInset(bounds, -42, -42));
	
	UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
	CGPathAddPath(path, NULL, innerPath.CGPath);
	
	CGPathCloseSubpath(path);
	
	[shadowMaskLayer setPath:path];
	CGPathRelease(path);
	
	
	[shadowLayer setMask:shadowMaskLayer];
	[self.contentViewController.view.superview.layer addSublayer:shadowLayer];
}

- (void)_setupPopoverBackgroundForView:(UIView *)view rect:(CGRect)rect arrowDirections:(UIPopoverArrowDirection)arrowDirections
{
    CGFloat arrowOffset = [self _arrowOffsetForRect:rect inView:view];
	CGRect popOverRect = [self _rectForPopoverBackgroundViewWithRect:rect inView:view arrowDirection:arrowDirections];
	
	self.popoverBackgroundView = [[GIKPopoverBackgroundView alloc] initWithFrame:popOverRect];
	self.popoverBackgroundView.popoverAttributes = self.popoverAttributes;
	self.popoverBackgroundView.arrowDirection = arrowDirections;
	self.popoverBackgroundView.arrowOffset = arrowOffset;
	
	[self.view addSubview:self.popoverBackgroundView];
}

- (void)_addContentViewToPopoverBackground
{
	
    CGFloat inset = self.arrowDirection == UIPopoverArrowDirectionDown ? 0 : self.popoverAttributes.popoverArrowHeight;
	CGRect frame = CGRectMake(self.popoverAttributes.popoverEdgeInsets.left, self.popoverAttributes.popoverEdgeInsets.top + inset, self.contentViewController.contentSizeForViewInPopover.width, self.contentViewController.contentSizeForViewInPopover.height);
	self.contentViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
	
	
	//we need to add the content view into a container
	//otherwise the clipping on UITableViewControllers doesn't work
	//properly
	UIView *containerView = [[UIView alloc] initWithFrame:frame];
	containerView.backgroundColor = [UIColor clearColor];
	[containerView addSubview:self.contentViewController.view];
	[self.popoverBackgroundView.popoverBackground addSubview:containerView];
}

- (void)_showPopoverAnimated:(BOOL)animated
{
    CGFloat animationSpeed = animated ? 0.1f : 0.0f;
	self.popoverBackgroundView.alpha = 0.0;
	[UIView animateWithDuration:animationSpeed animations:^{
		self.popoverBackgroundView.alpha = 1.0;
	}];
}

#pragma mark -
#pragma mark Action Methods

- (void)_actionDismissController:(UITapGestureRecognizer *)recognizer
{
	if ([self _delegateShouldDismissPopover]) {
		[self _delegateDidDismiss];
	}
	
	[self dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Public Methods

- (void)dismissPopoverAnimated:(BOOL)animated
{
	CGFloat animationSpeed = animated ? 0.2f : 0.0f;
	[UIView animateWithDuration:animationSpeed animations:^{
		self.popoverBackgroundView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
	}];
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
	UIView *responder = [item performSelector:@selector(nextResponder)];
	NSAssert(responder != nil, @"UIBarButtonItem's nextResponder is nil");
	
	NSInteger idx;
    idx = [self _indexForBarButtonItem:item barButtonParent:responder];
	
	UIView *viewItem = nil;
	NSInteger count = -1;
	for (viewItem in responder.subviews) {
		if([viewItem isKindOfClass:NSClassFromString(@"UIControl")]){
			if (++count == idx){
				break;
			}
		}
	}
	
	[self presentPopoverFromRect:viewItem.frame inView:responder permittedArrowDirections:arrowDirections animated:animated];
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
	self.arrowDirection = arrowDirections;
	
	//check arrow directions, right now support UIPopoverDirectionUp and UIPopoverDirectionDown
	NSAssert(self.arrowDirection != UIPopoverArrowDirectionAny ||
			 self.arrowDirection != UIPopoverArrowDirectionLeft ||
			 self.arrowDirection != UIPopoverArrowDirectionRight ||
			 self.arrowDirection != UIPopoverArrowDirectionUnknown, @"UIPopoverDirectionAny is not supported at the moment");
	
	//setup the popover background properly
	[self _setupPopoverBackgroundForView:view rect:rect arrowDirections:arrowDirections];
	
	
	//add the content view to the background with a certain inset
	[self _addContentViewToPopoverBackground];
	
	
	//show it
	[self _showPopoverAnimated:animated];
	
	
	//once we have added the content, we place a shadow on top of it
	[self _placeDropShadow];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	CGPoint point = [touch locationInView:self.view];
	UIView *view = [self.view hitTest:point withEvent:nil];
	do{
		if (view == self.popoverBackgroundView) {
			return NO;
		}
		
		view = view.superview;
	}while (view != nil);
	
	return YES;
}

#pragma mark -
#pragma mark UIViewController Methods

- (id)initWithContentViewController:(UIViewController *)contentViewController
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.contentViewController = contentViewController;
		self.contentViewController.view.layer.cornerRadius = 7.0f;
		self.contentViewController.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//setup own view
	self.view.backgroundColor = [UIColor clearColor];
	
	//add the controller view to the window
	UIWindow *window = [[UIApplication sharedApplication] delegate].window;
	self.view.frame = window.bounds;
	[window addSubview:self.view];
	
	//TapGestureRecognizer
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_actionDismissController:)];
	recognizer.delegate = self;
	[self.view addGestureRecognizer:recognizer];
}

@end
