//
//  RoundedRectOverlay.m
//  CloudPost
//
//  Created by Christian Stropp on 17.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RoundedRectOverlay.h"


@implementation RoundedRectOverlay

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds]
														xRadius:20.0
														yRadius:20.0];
	[[NSColor colorWithDeviceWhite:0.0 alpha:0.8] set];
	[path fill];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)becomeFirstResponder
{
	return YES;
}

- (BOOL)resignFirstResponder
{
	return NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	
}

@end
