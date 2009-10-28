//
//  TrackCell.m
//  CloudPost
//
//  Created by Christian Stropp on 11.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackCell.h"


@implementation TrackCell

@synthesize statusView;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[NSGraphicsContext saveGraphicsState];
	
	// size cellFrame to fill the whole cell
	cellFrame.origin.x -= 1;
	cellFrame.origin.y -= 1;
	cellFrame.size.width += 3;
	cellFrame.size.height += 2;
	
	if (cellFrame.size.height == 44.0)
	{
		cellFrame.origin.y += cellFrame.size.height - 24.0;
		cellFrame.size.height = 24.0;
	}
	
	if (cellFrame.size.height <= 24.0)
	{
		// Set Shadow
		[[NSColor blackColor] set]; //needed for shadow to be shown, but has no influence
		NSShadow *shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.3]];
		[shadow setShadowBlurRadius:3.0];
		[shadow set];
		
		// Draw Background
		NSRect frame = NSMakeRect(cellFrame.origin.x + 12, cellFrame.origin.y,
								   cellFrame.size.width - 24, cellFrame.size.height - 1);
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path setLineJoinStyle:NSRoundLineJoinStyle];
		[path appendBezierPathWithRoundedRect:frame xRadius:3.0 yRadius:3.0];
		
		NSColor *startingColor;
		NSColor *endingColor;
		
		if (![self isHighlighted]) {
			startingColor = [NSColor colorWithCalibratedRed:0.9609375 green:0.9609375 blue:0.9609375 alpha:1.0];
			endingColor = [NSColor colorWithCalibratedRed:0.9453125 green:0.9453125 blue:0.9453125 alpha:1.0];
		} else {
			startingColor = [NSColor colorWithCalibratedRed:0.9140625 green:0.93359375 blue:0.96484375 alpha:1.0];
			endingColor = [NSColor colorWithCalibratedRed:0.890625 green:0.91015625 blue:0.9375 alpha:1.0];
		}
		
		NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:startingColor
															  endingColor:endingColor] autorelease];
		[path fill];
		[gradient drawInBezierPath:path angle:90];
		
		[NSGraphicsContext restoreGraphicsState];
		
		[shadow release];
		
		// Draw Title
		frame = cellFrame;
		frame.origin.x += 20;
		frame.origin.y += 4;
		[[self title] drawAtPoint:frame.origin withAttributes:nil];
		
		// Draw Status View
		if (statusView)
		{
			frame = [statusView frame];
			frame.origin.x = cellFrame.origin.x + (cellFrame.size.width - (frame.size.width + 20.0));
			frame.origin.y = cellFrame.origin.y;
			[statusView setFrame:frame];
			[controlView addSubview:statusView];
		}
	}
	else
		[NSGraphicsContext restoreGraphicsState];
}

@end
