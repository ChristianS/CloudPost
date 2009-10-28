//
//  DropView.m
//  CloudPost
//
//  Created by Christian Stropp on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DropView.h"


@implementation DropView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
	if (highlighted)
	{
		[[[NSColor grayColor] colorWithAlphaComponent:0.2] set];
		[NSBezierPath fillRect:[self frame]];
	}
}

#pragma mark Dragging Destination
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    highlighted = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingExited:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    if(![self readFromPasteboard:pb]) {
        NSLog(@"Error: Could not read from dragging pasteboard");
        return NO;
    }
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    NSLog(@"concludeDragOperation:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb
{
    NSArray *types = [pb types];
    if ([types containsObject:NSFilenamesPboardType])
	{
        NSArray *filePaths = [pb propertyListForType:NSFilenamesPboardType];
		for (int i = 0; i < filePaths.count; i++)
			NSLog(@"%@", [filePaths objectAtIndex:i]);
		[windowController openDroppedFiles:filePaths];
		return YES;
    }
    return NO;
}

@end
