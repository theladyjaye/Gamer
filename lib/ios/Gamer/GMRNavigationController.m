//
//  GMRNavigationController.m
//  Gamer
//
//  Created by Adam Venturella on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRNavigationController.h"
#import "HazGame.h"

@interface UIToolbar(CustomImage)
@end

@implementation UIToolbar(CutsomImage)
- (void)drawRect:(CGRect)rect
{
	UIImage *image = [UIImage imageNamed: @"ToolbarBackground.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, image.size.height)];
}
@end


@interface UINavigationBar (CustomImage)
@end

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect
{
	UIImage *image = [UIImage imageNamed: @"NavigationBarBackground.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, image.size.height)];
}
@end

static UIViewController * rootController;


@implementation GMRNavigationController
@dynamic navigationBar;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super init];
	
	if(self)
	{
		rootController = rootViewController;
		[rootViewController retain];
		
		// force the view to load
		UIView * shim = self.view;
		shim = nil;
	}
	
	return self;
}

- (void)loadView
{
	UIView * baseView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 480.0)];
	navigationController     = [[UINavigationController alloc] initWithRootViewController:rootController];
	
	[baseView addSubview:navigationController.view];
	
	self.view = baseView;
	
	UIImage * image           = [UIImage imageNamed:@"NavigationBarBackgroundShadow.png"];
	navigationBarShadow       = [[UIImageView alloc] initWithImage:image];
	navigationBarShadow.frame = CGRectMake(0, 64.0, image.size.width, image.size.height);
	
	[self.view addSubview:navigationBarShadow];
	[rootController release];
	
	
	[self viewDidLoad];
}

- (UINavigationBar *)navigationBar
{
	return navigationController.navigationBar;
}

- (void)viewDidLoad
{	
	[super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[navigationController pushViewController:viewController animated:animated];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	[navigationController setNavigationBarHidden:hidden animated:animated];
	
	if(animated)
	{
		if(hidden)
		{
			[UIView animateWithDuration:0.25 
							 animations:^{navigationBarShadow.transform = CGAffineTransformMakeTranslation(0.0, -1 * (64.0));} 
							 completion:^(BOOL finished){navigationBarShadow.hidden = YES;}];
		}
		else 
		{
			navigationBarShadow.hidden = NO;
			[UIView animateWithDuration:0.25 
							 animations:^{
								 navigationBarShadow.transform = CGAffineTransformIdentity;
							 }];
		}
	}
	else 
	{
		if(hidden)
		{
			navigationBarShadow.hidden = YES;
			navigationBarShadow.transform = CGAffineTransformMakeTranslation(0.0, -1 * (64.0));
		}
		else 
		{
			navigationBarShadow.hidden = NO;
			navigationBarShadow.transform = CGAffineTransformIdentity;
		}
	}
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
	[navigationController setToolbarHidden:hidden animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[navigationController.topViewController viewDidAppear:animated];
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[navigationBarShadow removeFromSuperview];
	[super viewDidDisappear:animated];
}


-(void)dealloc
{
	[navigationController release];
	[navigationBarShadow release];
	[super dealloc];
}
@end
