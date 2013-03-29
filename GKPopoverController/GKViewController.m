//
//  GKViewController.m
//  GKPopoverController
//
//  Created by Georg Kitz on 2/27/13.
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

#import "GKViewController.h"
#import "GKPopoverController.h"

@interface GKViewController ()<GKPopoverControllerDelegate, UITableViewDataSource>
@property (nonatomic, strong) GKPopoverController *pCtr;
@end

@implementation GKViewController

#pragma mark -
#pragma mark Action Methods

- (void)showPopoverForBarButtonItem:(UIBarButtonItem *)item
{
	[self showPopoverFromBarButtonItem:item arrowDirection:UIPopoverArrowDirectionUp];
}

- (void)showPopoverForToolBarButtonItem:(UIBarButtonItem *)item
{
	[self showPopoverFromBarButtonItem:item arrowDirection:UIPopoverArrowDirectionDown];
}

- (void)showPopoverOnBottom:(UIButton *)item
{
	UIViewController *ctr = [[UIViewController alloc] init];
	ctr.view.backgroundColor = [UIColor redColor];
	ctr.contentSizeForViewInPopover = CGSizeMake(200, 200);
	
	self.pCtr = [[GKPopoverController alloc] initWithContentViewController:ctr];
	self.pCtr.delegate = self;
	[self.pCtr presentPopoverFromRect:item.frame inView:item.superview permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)showPopoverFromBarButtonItem:(UIBarButtonItem *)item arrowDirection:(UIPopoverArrowDirection)direction
{	
	UITableViewController *ctr = [UITableViewController new];
	ctr.contentSizeForViewInPopover = CGSizeMake(280, 280);

	[ctr.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
	ctr.tableView.dataSource = self;
	
	self.pCtr = [[GKPopoverController alloc] initWithContentViewController:ctr];
	self.pCtr.delegate = self;
	[self.pCtr presentPopoverFromBarButtonItem:item permittedArrowDirections:direction animated:YES];
}



#pragma mark -
#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	//setup top navigationitems
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Top Left" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopoverForBarButtonItem:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Top Right" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopoverForBarButtonItem:)];
	
	
	//setup center buttpn
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(60, 320, 200, 44);
	[btn setTitle:@"Tap me!" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(showPopoverOnBottom:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	
	
	//setup toolbar with button
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 420 - 44, 320, 44)];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Bottom Left" style:UIBarButtonItemStyleBordered target:self action:@selector(showPopoverForToolBarButtonItem:)];
	toolbar.items = @[item];
	
	[self.view addSubview:toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
	cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
	
	return cell;
}

@end
