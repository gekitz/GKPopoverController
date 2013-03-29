### GKPopoverController ###

Ever wanted the UIPopoverController to work on the iPhone? You might find a possible solution for your problem in `GKPopoverController`. It basically works the same way as UIPopoverController. Right now 2 arrow directions `UIPopoverArrowDirectionUp & UIPopoverArrowDirectionDown` are supported. 

<br>
Special thanks to my friend [Darran Morris](http://twitter.com/darranmorris) who created the image assets for the popover background. Recommend contacting him if you have a design gig as he is a brilliant designer.

### How to use it

- just drag and drop the files in under "GKClasses" & "GKImages" into your project.
- look at the sample code below.
- this project contains a sample project as well, just have a look at the implementation of `GKViewController.m` 
- have fun and follow [@gekitz](http://www.twitter.com/gekitz).

### What about a custom popover background

As the background of the controller is based on a modified version of [GIKPopoverBackgroundView](https://github.com/GiK/GIKPopoverBackgroundView) from [@gordonhughes](https://twitter.com/gordonhughes) you can simply exchanges the images in the "GKImages" folder. If your images aren't completely the same dimensions as the provided images take a look into `GKPopoverAttributes.h` which provides a lot of information how to customize the background with your images.

### Sample Code
	
	UIViewController *ctr = [[UIViewController alloc] init];
	ctr.view.backgroundColor = [UIColor redColor];
	ctr.contentSizeForViewInPopover = CGSizeMake(200, 200);
	
	self.pCtr = [[GKPopoverController alloc] initWithContentViewController:ctr];
	self.pCtr.delegate = self;
	[self.pCtr presentPopoverFromRect:item.frame inView:item.superview permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
     

This code presents the following GKPopoverController:

![Sample View in GKPopoverController](https://dl.dropbox.com/u/311618/GKPopoverController/1.png)

<br><br>
Another example:

![Sample TableView in GKPopoverController](https://dl.dropbox.com/u/311618/GKPopoverController/2.png)

### License
Under MIT. See license file for details.



    