//
//  GMRChooseDescription.m
//  Gamer
//
//  Created by Adam Venturella on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GMRChooseDescription.h"
#import "GMRCreateGameGlobals.h"
#import "GMRMatch.h"


static CGFloat baseHeight = 34.0;
static CGFloat maxHeight  = 52.0;
static CGFloat currentHeight;

@implementation GMRChooseDescription
@synthesize textField, proxyTextField;


- (void)viewDidLoad 
{
	self.textField.contentInset = UIEdgeInsetsZero;
	[self.textField becomeFirstResponder];
	
	if(kCreateMatchProgress.label)
	{
		textField.text = kCreateMatchProgress.label;
		// TODO:  change height here if necessary!
	}
	
	currentHeight = self.textField.contentSize.height;
	
	[super viewDidLoad];
}

- (void)textViewDidChange:(UITextView *)textView
{
	
	CGFloat candidateHeight = textField.contentSize.height;
	if(candidateHeight >= baseHeight && candidateHeight <= maxHeight)
	{
		CGFloat newY = candidateHeight == baseHeight ? 9.0 : 1.0;
		if(currentHeight != candidateHeight)
		{
			currentHeight = candidateHeight;
			[UIView animateWithDuration:0.35 
							 animations:^{
								 textField.frame = CGRectMake(textField.frame.origin.x, newY, textField.frame.size.width, currentHeight);
							 }];
		
		}
	}
	
	kCreateMatchProgress.label = textField.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	BOOL result = YES;
	proxyTextField.text = [textField.text stringByAppendingString:text];
	
	// you would think this would work, but it's off.
	/*
	NSString * newValue =[textView.text stringByAppendingString:text];	
	CGSize newSize = [newValue
					  sizeWithFont:textField.font
					  constrainedToSize:CGSizeMake(textField.contentSize.width, 54.0)
					  lineBreakMode:UILineBreakModeCharacterWrap];
	 */
	
	//NSLog(@"%f, %f", textField.contentSize.width, textField.frame.size.width);
	if(proxyTextField.contentSize.height > maxHeight)
		result = NO;
		
	return result;
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

- (void) viewWillDisappear:(BOOL)animated
{
	[self.textField resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.textField = nil;
	self.proxyTextField = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
