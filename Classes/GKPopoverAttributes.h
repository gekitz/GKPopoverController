//
//  GKPopoverAttributes.h
//  GKPopoverController
//
//  Created by Georg Kitz on 2/28/13.
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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface GKPopoverAttributes : NSObject

/**
 Filenames for the seven required background images. If a popover's arrowDirection is UIPopoverArrowDirectionLeft, the equivalent right-facing image will be mirrored.
 */

@property (nonatomic, strong) UIImage *arrowUp;
@property (nonatomic, strong) UIImage *arrowUpRight;
@property (nonatomic, strong) UIImage *arrowDown;
@property (nonatomic, strong) UIImage *arrowDownRight;
@property (nonatomic, strong) UIImage *arrowSide;
@property (nonatomic, strong) UIImage *arrowSideTop;
@property (nonatomic, strong) UIImage *arrowSideBottom;


/**
 Image-specific cap insets which specify a 1 point by 1 point area to be stretched. Changing the background images will likely require a different set of insets.
 */
@property (nonatomic, assign) UIEdgeInsets arrowUpInsets;
@property (nonatomic, assign) UIEdgeInsets arrowUpRightInsets;
@property (nonatomic, assign) UIEdgeInsets arrowDownInsets;
@property (nonatomic, assign) UIEdgeInsets arrowDownRightInsets;
@property (nonatomic, assign) UIEdgeInsets arrowSideInsets;
@property (nonatomic, assign) UIEdgeInsets arrowSideTopInsets;
@property (nonatomic, assign) UIEdgeInsets arrowSideBottomInsets;


/**
 Image-specific values for calulating the background's layout.
 */
@property (nonatomic, assign) CGFloat popoverArrowWidth; // Returned by +arrowBase, irrespective of orientation. The length of the base of the arrow's triangle.
@property (nonatomic, assign) CGFloat popoverArrowHeight; // Returned by +arrowHeight, irrespective of orientation. The height of the arrow from base to tip.
@property (nonatomic, assign) CGFloat popoverCornerRadius;  // Used in a bounds check to determine if the arrow is too close to the popover's edge.
@property (nonatomic, assign) CGFloat sideArrowCenterOffset;  // Added to the arrow's center for ...Side.png image to account for the taller top half.

/**
 Content and background insets.
 */
@property (nonatomic, assign) UIEdgeInsets popoverEdgeInsets; // Distance between the edge of the background view and the edge of the content view.

@property (nonatomic, assign) CGFloat secondHalfBottomInset; // Value for .bottom inset in the second half of a two-part vertical stretch operation.
@property (nonatomic, assign) CGFloat secondHalfRightInset; // Value for .right inset in the seconf half of a two-part horizontal stretch operation.

+ (instancetype)defaultAttributes;

@end
