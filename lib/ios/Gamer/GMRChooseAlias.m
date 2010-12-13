//
//  GMRChooseAlias.m
//  Gamer
//
//  Created by Adam Venturella on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseAlias.h"
#import "GMRLabel.h"
#import "GMRAlias.h"
#import "GMRCreateAliasGlobals.h"

@implementation GMRChooseAlias
@synthesize aliasTextField;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad 
{
    self.navigationItem.titleView = [GMRLabel titleLabelWithString:@"Alias"];
	
	if(kCreateAliasProgress.alias && [kCreateAliasProgress.alias length] >= 3)
	{
		
		aliasTextField.text = kCreateAliasProgress.alias;
	}
	
	
	[aliasTextField addTarget:self 
					   action:@selector(textFieldDidChange:) 
			 forControlEvents:UIControlEventEditingChanged];
	
	[aliasTextField becomeFirstResponder];
	
	[super viewDidLoad];
}

- (void)textFieldDidChange:(id)sender
{
	kCreateAliasProgress.alias = [aliasTextField.text length] > 0 ? aliasTextField.text : nil;
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	
	
	return YES;
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
	[aliasTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.aliasTextField = nil;
}


- (void)dealloc {
	[aliasTextField removeTarget:self 
						  action:@selector(textFieldDidChange:) 
				forControlEvents:UIControlEventEditingChanged];
	
	self.aliasTextField = nil;
    [super dealloc];
}


@end
