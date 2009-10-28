//
//  TrackEditView.m
//  CloudPost
//
//  Created by Christian Stropp on 17.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackEditView.h"
#import "TracksTableView.h"


@implementation TrackEditView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)awakeFromNib
{
	// observe button content to resize button to content size
	[controller addObserver:self forKeyPath:@"selection.track_type" options:0 context:nil];
	[controller addObserver:self forKeyPath:@"selection.license" options:0 context:nil];
	
	// set gray title for placeholder in popupbutton menu item
	NSDictionary *style = [NSDictionary  dictionaryWithObjectsAndKeys:
						   [NSColor grayColor], NSForegroundColorAttributeName,
						   [type font], NSFontAttributeName, nil];
	NSMenuItem *item = [type itemAtIndex:0];
	NSAttributedString *atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateYear itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateMonth itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateDay itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	// menu item images
	NSMenuItem *ccItem;
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:2]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:3]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:4]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC-ND"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:5]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC-SA"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:6]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-SA"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:7]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-ND"]];
}


- (void)drawRect:(NSRect)rect
{
	NSRect viewFrame = [self bounds];
	
	[NSGraphicsContext saveGraphicsState];
	
	[[NSColor colorWithDeviceWhite:0.78125 alpha:1.0] set];
	NSRectFill(viewFrame);
	
	/* Draw Shadow */
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.7]];
	[shadow setShadowBlurRadius:5.0];
	[shadow set];
	
	/* Draw Control */
	NSRect frame = NSMakeRect(viewFrame.origin.x + 12, viewFrame.origin.y + 8,
							  viewFrame.size.width - 24, viewFrame.size.height - 14);
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineJoinStyle:NSRoundLineJoinStyle];
	[path appendBezierPathWithRoundedRect:frame xRadius:3.0 yRadius:3.0];
	
	[[NSColor whiteColor] set];
	[path fill];
	
	[NSGraphicsContext restoreGraphicsState];
	
	[shadow release];
}


- (IBAction)toggleTrackDetailsView:(id)sender
{
	if (![tracksTable openRowIsExpanded])
	{
		NSRect detailsFrame = [self frame];
		detailsFrame = NSMakeRect(0.0, 12.0, [self frame].size.width, [trackDetailsView frame].size.height);
		[trackDetailsView setFrame:detailsFrame];
		
		NSRect frame = [self frame];
		frame.size.height += [trackDetailsView frame].size.height;
		[self setFrame:frame];
		
		[tracksTable setOpenRowIsExpanded:YES];
		[self addSubview:trackDetailsView];
		[genre becomeFirstResponder];
		
		// set gray title for placeholder in popupbutton menu item
		NSDictionary *style = [NSDictionary  dictionaryWithObjectsAndKeys:
							   [NSColor grayColor], NSForegroundColorAttributeName,
							   [type font], NSFontAttributeName, nil];
		NSMenuItem *item = [releaseDateYear itemAtIndex:0];
		NSAttributedString *atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
		[item setAttributedTitle:atted];
		[atted release];
	}
	else
	{
		NSRect frame = [self frame];
		frame.size.height -= [trackDetailsView frame].size.height;
		[self setFrame:frame];
		
		[trackDetailsView removeFromSuperview];
		[tracksTable setOpenRowIsExpanded:NO];
	}
	
	[self setNeedsDisplay:YES];
	[tracksTable scrollRowToVisible:[tracksTable openRow]];
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


#pragma mark Key-Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == controller)
	{
		if ([keyPath isEqualToString:@"selection.track_type"])
		{
			NSString *title = [[type selectedItem] title];
			NSCell *cell = [[NSCell alloc] initTextCell:title];
			NSSize size = [cell cellSize];
			[cell release];
			
			NSRect frame = [type frame];
			frame.size.width = size.width + 20.0;
			[type setFrame:frame];
		}
		else if ([keyPath isEqualToString:@"selection.license"])
		{
			NSString *title = [[license selectedItem] title];
			NSImage *img = [[license selectedItem] image];
			NSCell *cell = [[NSCell alloc] initTextCell:title];
			CGFloat width = [cell cellSize].width + [img size].width;
			[cell release];
			
			NSRect frame = [license frame];
			frame.size.width = width + 20.0;
			[license setFrame:frame];
		}
	}
}

@end
