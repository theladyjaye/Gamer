//
//  GMRChoosePlayers.m
//  Gamer
//
//  Created by Adam Venturella on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChoosePlayers.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMatch.h"
#import "GMRGame.h"
#import "GMRLabel.h"

@implementation GMRChoosePlayers
@synthesize label, pickerView;

- (void)viewDidLoad 
{
	self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Players"];
	
	if(kCreateMatchProgress.players)
	{
		self.label.text = [NSString stringWithFormat:@"%i Players", kCreateMatchProgress.players];
		[pickerView selectRow:(kCreateMatchProgress.players - 1) inComponent:0 animated:NO];
	}
	
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	if(!kCreateMatchProgress.players)
	{
		kCreateMatchProgress.players = 1;
	}
	
	[super viewDidAppear:animated];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return kCreateMatchProgress.game.maxPlayers;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%i", (row + 1)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.label.text = [NSString stringWithFormat:@"%i Players", (row + 1)];
	kCreateMatchProgress.players = (row + 1);
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.label = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
