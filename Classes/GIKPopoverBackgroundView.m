//
//  GIKPopoverBackgroundView.m
//
//  Created by Gordon Hughes on 1/7/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

#import "GIKPopoverBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

// A struct containing the min and max horizontal and vertical positions for the popover arrow. If the arrow's position exceeds these limits, the PopoverBackgroundArrow[UpRight|DownRight|SideTop|SideBottom].png images are drawn.
struct GIKPopoverExtents {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
};
typedef struct GIKPopoverExtents GIKPopoverExtents;

@interface GIKPopoverBackgroundView () {
    GIKPopoverExtents _popoverExtents;
    CGFloat _halfBase;
    CGFloat _arrowCenter;
}

@property (strong, nonatomic, readwrite) UIImageView *popoverBackground;

@end


@implementation GIKPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;


#pragma mark - UIPopoverBackgroundView required values

- (CGFloat)halfArrowBase
{
    return _popoverAttributes.popoverArrowWidth / 2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		self.userInteractionEnabled = YES;
		
		_popoverBackground = [[UIImageView alloc] initWithFrame:(CGRect){ .origin = CGPointZero, .size = frame.size }];
		_popoverBackground.userInteractionEnabled = YES;
        [self addSubview:_popoverBackground];
    }
    return self;
}

- (void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    
	// -setArrowOffset is called inside an animation block managed by the UIPopoverController. If the frame of our popover is changing because, say, the keyboard is appearing or disappearing, we need to explicitly animate the shadowPath; implicit - in this case, UIKit - animations don't work on the shadowPath - the path will jump to its final value with no inbetweening.
	CGPathRef shadowPathRef = [self shadowPath];
	[self addShadowPathAnimationIfNecessary:shadowPathRef]; // Comment out this line to see the effect of no explicit animation on the shadowPath.
	self.popoverBackground.layer.shadowPath = shadowPathRef;
    [self setNeedsLayout];
}

- (void)addShadowPathAnimationIfNecessary:(CGPathRef)pathRef
{
    // If the layer's animationKeys array contains a string with the value "bounds", we know its frame is changing. Get the timingFunction and duration properties of that animation, and apply them to the shadowPath animation so that the two are in sync.
    NSArray *animationKeys = [self.popoverBackground.layer animationKeys];
    if ([animationKeys containsObject:@"bounds"])
    {
        CAAnimation *boundsAnimation = [self.popoverBackground.layer animationForKey:@"bounds"];
        CABasicAnimation *shadowPathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        shadowPathAnimation.toValue = [NSValue valueWithPointer:pathRef];
        shadowPathAnimation.timingFunction = boundsAnimation.timingFunction;
        shadowPathAnimation.duration = boundsAnimation.duration;
        [self.popoverBackground.layer addAnimation:shadowPathAnimation forKey:@"shadowPath"];
    }
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self addDropShadowIfNecessary]; // Once we know the arrow's direction, we can add a drop shadow manually if we're on iOS 5.x.
    [self setNeedsLayout];
}

- (void)addDropShadowIfNecessary
{
	CALayer *layer = self.popoverBackground.layer;
	layer.shadowColor = [UIColor blackColor].CGColor;
	layer.shadowOpacity = 0.9;
	layer.shadowRadius = 20.0;
	layer.shadowOffset = (CGSize){ .width = 0.0, .height = 10.0 };
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    _popoverExtents = (GIKPopoverExtents){
        .left   = CGRectGetMinX(self.bounds) + _popoverAttributes.popoverCornerRadius,
        .right  = CGRectGetMaxX(self.bounds) - _popoverAttributes.popoverCornerRadius,
        .top    = CGRectGetMinY(self.bounds) + _popoverAttributes.popoverCornerRadius,
        .bottom = CGRectGetMaxY(self.bounds) - _popoverAttributes.popoverCornerRadius
    };
    
    _halfBase = [self halfArrowBase];
    _arrowCenter = [self arrowCenter];
    
    // Because layoutSubviews is called on device rotation, the popoverBackground's center and bounds are reset so that any left arrow adjustments or frame resizing can be recalculated from their initial values.
    self.popoverBackground.frame = self.bounds;
    self.popoverBackground.image = [self wantsUpOrDownArrow] ? [self upOrDownArrowImage] : [self sideArrowImage];
}


#pragma mark - Custom Layout

- (CGPathRef)shadowPath
{
    CGRect pathRect = self.bounds;
    
    if ([self wantsUpOrDownArrow])
    {
        pathRect.origin.y = [self wantsUpArrow] ? _popoverAttributes.popoverArrowHeight : 0.0;
        pathRect.size.height -= _popoverAttributes.popoverArrowHeight;
    }
    else
    {
        pathRect.origin.x = (self.arrowDirection == UIPopoverArrowDirectionLeft) ? _popoverAttributes.popoverArrowHeight : 0.0;
        pathRect.size.width -= _popoverAttributes.popoverArrowHeight;
    }
    
    return [UIBezierPath bezierPathWithRect:pathRect].CGPath;
	return NULL;
}

- (UIImage *)upOrDownArrowImage
{
    UIImage *image;
    UIEdgeInsets insets;
    BOOL wantsUpArrow = [self wantsUpArrow];
    
    if ([self isArrowBetweenLeftAndRightEdgesOfPopover])
    {
        image = (wantsUpArrow) ? _popoverAttributes.arrowUp : _popoverAttributes.arrowDown;
        insets = (wantsUpArrow) ? _popoverAttributes.arrowUpInsets : _popoverAttributes.arrowDownInsets;
        return [self twoPartStretchableImage:image insets:insets];
    }
    else
    {
        image = (wantsUpArrow) ? _popoverAttributes.arrowUpRight : _popoverAttributes.arrowDownRight;
        insets = (wantsUpArrow) ? _popoverAttributes.arrowUpRightInsets : _popoverAttributes.arrowDownRightInsets;
        return [self stretchableImage:image insets:insets mirrored:[self isArrowAtLeftEdgeOfPopover]];
    }
}

- (UIImage *)sideArrowImage
{
    [self adjustCentersIfNecessary];
    
    if ([self isArrowBetweenTopAndBottomEdgesOfPopover])
    {
        return [self twoPartStretchableImage:_popoverAttributes.arrowSide insets:_popoverAttributes.arrowSideInsets];
    }
    else
    {
        UIImage *image = [self isArrowAtTopEdgeOfPopover] ? _popoverAttributes.arrowSideTop : _popoverAttributes.arrowSideBottom;
        UIEdgeInsets insets = [self isArrowAtTopEdgeOfPopover] ? _popoverAttributes.arrowSideTopInsets : _popoverAttributes.arrowSideBottomInsets;
        return [self stretchableImage:image insets:insets mirrored:(self.arrowDirection == UIPopoverArrowDirectionLeft)];
    }
}

- (CGFloat)arrowCenter
{
    CGFloat mid = ([self wantsUpOrDownArrow]) ? CGRectGetMidX(self.bounds) : CGRectGetMidY(self.bounds);
    return mid + self.arrowOffset;
}


- (BOOL)wantsUpOrDownArrow { return ([self wantsUpArrow] || self.arrowDirection == UIPopoverArrowDirectionDown); }

- (BOOL)wantsUpArrow { return (self.arrowDirection == UIPopoverArrowDirectionUp); }

- (BOOL)isArrowBetweenLeftAndRightEdgesOfPopover { return ![self isArrowAtRightEdgeOfPopover] && ![self isArrowAtLeftEdgeOfPopover]; }

- (BOOL)isArrowAtLeftEdgeOfPopover { return (_arrowCenter - _halfBase < _popoverExtents.left); }

- (BOOL)isArrowAtRightEdgeOfPopover { return (_arrowCenter + _halfBase > _popoverExtents.right); }

- (BOOL)isArrowBetweenTopAndBottomEdgesOfPopover { return ![self isArrowAtTopEdgeOfPopover] && ![self isArrowAtBottomEdgeOfPopover]; }

- (BOOL)isArrowAtTopEdgeOfPopover { return (_arrowCenter - _halfBase < _popoverExtents.top); }

- (BOOL)isArrowAtBottomEdgeOfPopover { return (_arrowCenter + _halfBase > _popoverExtents.bottom); }


- (void)adjustCentersIfNecessary
{
     // fix centers of left-pointing popovers so that their shadows are drawn correctly.   
    if (self.arrowDirection == UIPopoverArrowDirectionLeft)
    {
        self.center = (CGPoint){ .x = self.center.x + _popoverAttributes.popoverArrowHeight, .y = self.center.y };
        self.popoverBackground.center = (CGPoint){ .x = self.popoverBackground.center.x - _popoverAttributes.popoverArrowHeight, .y = self.popoverBackground.center.y };
    }
}


#pragma mark - Stretching

- (UIImage *)stretchableImage:(UIImage *)image insets:(UIEdgeInsets)insets mirrored:(BOOL)mirrored
{
    return (mirrored) ? [[self mirroredImage:image] resizableImageWithCapInsets:[self mirroredInsets:insets]] : [image resizableImageWithCapInsets:insets];
}

- (UIImage *)twoPartStretchableImage:(UIImage *)image insets:(UIEdgeInsets)insets
{
    if (self.arrowDirection == UIPopoverArrowDirectionLeft)
    {
        image = [self mirroredImage:image];
        insets = [self mirroredInsets:insets];
    }
    
    UIImage *firstHalfImage = [image resizableImageWithCapInsets:insets];
    UIImage *stretchedImage = [self imageFromImageContextWithSourceImage:firstHalfImage size:[self contextSizeForFirstHalfImage:image]];
    return [stretchedImage resizableImageWithCapInsets:[self secondHalfInsetsForStretchedImage:stretchedImage insets:insets]];
}

- (CGFloat)firstHalfStretchAmountForImage:(UIImage *)image
{
    return [self wantsUpOrDownArrow] ? _arrowCenter + (image.size.width - 1) / 2.0 : _arrowCenter + (image.size.height / 2) - 1 - _popoverAttributes.sideArrowCenterOffset;
}

- (CGSize)contextSizeForFirstHalfImage:(UIImage *)image
{
    CGFloat stretch = [self firstHalfStretchAmountForImage:image];
    return [self wantsUpOrDownArrow] ? (CGSize){ .width = stretch, .height = image.size.height } : (CGSize){ .width = image.size.width, .height = stretch };
}

- (UIEdgeInsets)secondHalfInsetsForStretchedImage:(UIImage *)stretchedImage insets:(UIEdgeInsets)insets
{
    return [self wantsUpOrDownArrow] ? [self horizontalInsetsForStretchedImage:stretchedImage insets:insets] : [self verticalInsetsForStretchedImage:stretchedImage insets:insets];
}

- (UIEdgeInsets)horizontalInsetsForStretchedImage:(UIImage *)stretchedImage insets:(UIEdgeInsets)insets
{
    return (UIEdgeInsets){ .top = insets.top, .left = stretchedImage.size.width - (kSecondHalfRightInset + 1), .bottom = insets.bottom, .right = kSecondHalfRightInset };
}

- (UIEdgeInsets)verticalInsetsForStretchedImage:(UIImage *)stretchedImage insets:(UIEdgeInsets)insets
{
    return (UIEdgeInsets){ .top = stretchedImage.size.height - (kSecondHalfBottomInset + 1), .left = insets.left, .bottom = kSecondHalfBottomInset, .right = insets.right };
}

- (UIImage *)mirroredImage:(UIImage *)image
{
    UIImage *mirror = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUpMirrored];
    return [self imageFromImageContextWithSourceImage:mirror size:mirror.size];
}

- (UIEdgeInsets)mirroredInsets:(UIEdgeInsets)insets
{
    // Swap left and right insets for a mirrored image.
    return UIEdgeInsetsMake(insets.top, insets.right, insets.bottom, insets.left);
}

- (UIImage *)imageFromImageContextWithSourceImage:(UIImage *)image size:(CGSize)size
{
    // Stretching/tiling only takes place when the image is drawn, so the mirrored or stretched image is first drawn into a context before applying additional stretching.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:(CGRect){ .origin = CGPointZero, .size = size }];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
