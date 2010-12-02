//
//  GMRChooseDateTime.m
//  Gamer
//
//  Created by Adam Venturella on 11/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseDateTime.h"
#import "GMRMatch.h"
#import "GMRCreateGameGlobals.h"
#import "NSDate+JSON.h"
#import "GMRLabel.h"

@implementation GMRChooseDateTime
@synthesize datePicker, label;

- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Date and Time"];
	
	if(kCreateMatchProgress.scheduled_time)
	{
		[datePicker setDate:kCreateMatchProgress.scheduled_time animated:NO];
		self.label.text = [NSDate gamerScheduleTimeString:kCreateMatchProgress.scheduled_time];
	}

	
	[datePicker addTarget:self 
				   action:@selector(pickerChanged) 
		 forControlEvents:UIControlEventValueChanged];
	
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	if(!kCreateMatchProgress.scheduled_time)
	{
		NSDate * now = [NSDate dateWithTimeIntervalSinceNow:1.0];
		kCreateMatchProgress.scheduled_time = now;
		self.label.text = [NSDate gamerScheduleTimeString:kCreateMatchProgress.scheduled_time];
		self.datePicker.minimumDate = now;
		[datePicker setDate:now animated:NO];
	}
	
	[super viewDidAppear:animated];
}

- (void)pickerChanged
{
	kCreateMatchProgress.scheduled_time = datePicker.date;
	self.label.text = [NSDate gamerScheduleTimeString:kCreateMatchProgress.scheduled_time];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.datePicker = nil;
	self.label = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
