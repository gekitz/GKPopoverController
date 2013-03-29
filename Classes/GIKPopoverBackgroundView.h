//
//  GIKPopoverBackgroundView.h
//
//  Created by Gordon Hughes on 1/7/13.
//  Copyright (c) 2013 Gordon Hughes. All rights reserved.
//

// To use, import this header in your class and add the following after the popover controller's declaration/instantiation:

// popoverController.popoverBackgroundViewClass = [GIKPopoverBackgroundView class];

// Layout of images will be handled automatically, and it works with all values of UIPopoverArrowDirection.

#import <UIKit/UIKit.h>
#import "GKPopoverAttributes.h"

/**
 Content and background insets.
 */
static const UIEdgeInsets kPopoverEdgeInsets = { 20.0,  20.0,  50.0,  50.0}; // Distance between the edge of the background view and the edge of the content view.

static const CGFloat kSecondHalfBottomInset         = 7.0; // Value for .bottom inset in the second half of a two-part vertical stretch operation.
static const CGFloat kSecondHalfRightInset          = 7.0; // Value for .right inset in the seconf half of a two-part horizontal stretch operation.

@interface GIKPopoverBackgroundView : UIView
{
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
	GKPopoverAttributes *_popoverAttributes;
}

@property (nonatomic, assign) CGFloat arrowOffset;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readonly) UIImageView *popoverBackground;

@property (nonatomic, strong) GKPopoverAttributes *popoverAttributes;

@end
