//
//  CPStatusViewController.m
//  CloudPost
//
//  Created by Christian Stropp on 26.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPStatusViewController.h"


@implementation CPStatusViewController

@synthesize finishedSuccessfully;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		finishedSuccessfully = NO;
	}
	return self;
}


- (void)showProgressBar
{
	[successImage setHidden:YES];
	[errorImage setHidden:YES];
	[progressBar setHidden:NO];
	[progressBar startAnimation:self];
}


- (void)setProgress:(double)progress
{
	[progressBar setHidden:NO];
	[progressBar setDoubleValue:progress];
}


- (void)finishSuccessful:(BOOL)success
{
	[progressBar setHidden:YES];
	[successImage setHidden:!success];
	[errorImage setHidden:success];
	
	if (success)
		finishedSuccessfully = YES;
}

@end
