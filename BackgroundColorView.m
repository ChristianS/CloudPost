//
//  BackgroundColorView.m
//  CloudPost
//
//  Created by Christian Stropp on 29.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BackgroundColorView.h"


@implementation BackgroundColorView

@synthesize backgroundColor;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
	[backgroundColor set];
	NSRectFill(rect);
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

@end
