//
//  GKPopoverAttributes.m
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

#import "GKPopoverAttributes.h"

static const CGFloat kPopoverArrowWidth         = 40.0;
static const CGFloat kPopoverArrowHeight        = 20.0;
static const CGFloat kPopoverCornerRadius       = 7.0;  
static const CGFloat kSideArrowCenterOffset     = 7.0;

static const UIEdgeInsets kPopoverEdgeInsets = { 10.0,  10.0,  10.0,  10.0};

static const CGFloat kSecondHalfBottomInset         = 7.0; 
static const CGFloat kSecondHalfRightInset          = 7.0; 

static const UIEdgeInsets kArrowUpInsets            = {42.0,  6.0,  9.0, 50.0};
static const UIEdgeInsets kArrowUpRightInsets       = {41.0,  4.0,  9.0, 44.0};
static const UIEdgeInsets kArrowDownInsets          = {23.0,  6.0, 27.0, 50.0};
static const UIEdgeInsets kArrowDownRightInsets     = {23.0,  9.0, 27.0, 42.0};
static const UIEdgeInsets kArrowSideInsets          = {24.0,  9.0, 47.0, 27.0};
static const UIEdgeInsets kArrowSideTopInsets       = {43.0,  9.0,  9.0, 27.0};
static const UIEdgeInsets kArrowSideBottomInsets    = {23.0,  9.0, 43.0, 27.0};

@implementation GKPopoverAttributes

#pragma mark -
#pragma mark init 

+ (instancetype)defaultAttributes
{
	return [[GKPopoverAttributes alloc] init];
}

- (instancetype)init
{
	if (self = [super init]) {
		
		[self setupDefaultImages];
		[self setupDefaultInsets];
		
		self.popoverArrowWidth = kPopoverArrowWidth;
		self.popoverArrowHeight = kPopoverArrowHeight;
		self.popoverCornerRadius = kPopoverCornerRadius;
		self.sideArrowCenterOffset = kSideArrowCenterOffset;
		
		self.popoverEdgeInsets = kPopoverEdgeInsets;
		self.secondHalfBottomInset = kSecondHalfBottomInset;
		self.secondHalfRightInset = kSecondHalfRightInset;
	}
	
	return self;
}

#pragma mark -
#pragma mark setup methods

- (void)setupDefaultImages
{
	self.arrowUp = [UIImage imageNamed:@"PopoverBackgroundArrowUp"];
	self.arrowUpRight = [UIImage imageNamed:@"PopoverBackgroundArrowUpRight"];
	self.arrowDown = [UIImage imageNamed:@"PopoverBackgroundArrowDown"];
	self.arrowDownRight = [UIImage imageNamed:@"PopoverBackgroundArrowDownRight"];
	self.arrowSide = [UIImage imageNamed:@"PopoverBackgroundArrowSide"];
	self.arrowSideTop = [UIImage imageNamed:@"PopoverBackgroundArrowSideTop"];
	self.arrowSideBottom = [UIImage imageNamed:@"PopoverBackgroundArrowSideBottom"];
}

- (void)setupDefaultInsets
{
	self.arrowUpInsets = kArrowUpInsets;
	self.arrowUpRightInsets = kArrowUpRightInsets;
	self.arrowDownInsets = kArrowDownInsets;
	self.arrowDownRightInsets = kArrowDownRightInsets;
	self.arrowSideInsets = kArrowSideInsets;
	self.arrowSideTopInsets = kArrowSideTopInsets;
	self.arrowSideBottomInsets = kArrowSideBottomInsets;
}

@end
