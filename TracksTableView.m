//
//  TracksTableView.m
//  CloudPost
//
//  Created by Christian Stropp on 11.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TracksTableView.h"
#import "TrackEditView.h"
#import "TrackCell.h"
#import "NSMutableArray-Tracks.h"
#import "CPUploadSetViewController.h"
#import "Track.h"


@implementation TracksTableView

@synthesize openRow;

- (void)awakeFromNib
{
	[self setTarget:self];
	[self setAction:@selector(selectTrack:)];
	[self setDoubleAction:@selector(toggleTrack:)];
	[self setDelegate:self];
	openRow = -1;
	openRowIsExpanded = NO;
	
	NSShadow *shdw = [[NSShadow alloc] init];
	[shdw setShadowColor:[NSColor redColor]];
	[shdw setShadowOffset:NSMakeSize(5.0, 5.0)];
	[shdw setShadowBlurRadius:10.0];
	[trackEditView setShadow:shdw];
	[shdw set];
	
	[self deselectAll:self];
	
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

/*
- (BOOL)resignFirstResponder
{
	NSResponder *firstResponder = [[self window] firstResponder];
	
	if (![[self subviews] containsObject:firstResponder])
	{
		[self deselectAll:self];
		if (openRow != -1)
		{
			openRow = -1;
			if (openRowIsExpanded)
				[trackEditView toggleTrackDetailsView:self];
			[trackEditView removeFromSuperview];
		}
		NSLog(@"jo");
	}
	
	
	return YES;
}
*/

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	CGFloat height = 22.0;
	
	if (openRow == row)
	{
		height += 84;
		if (openRowIsExpanded)
			height += 144;
	}
	
	// first row should be bigger
	if (row == 0)
		height += 20;
	
	return height;
}


- (void)keyDown:(NSEvent *)theEvent
{
	switch ([theEvent keyCode]) {
		case 117: // delete
		case 51:  // backspace
			if (openRow == -1)
			{
				NSIndexSet* indexes = [tracksController selectionIndexes];
				NSUInteger index = [indexes indexGreaterThanOrEqualToIndex:0];
				while (index != NSNotFound)
				{
					Track *track = [[tracksController arrangedObjects] objectAtIndex:index];
					[[[track statusViewController] view] removeFromSuperview];
					
					//if (track.uploadStatus >= kUploadStatusUploaded)
						// TODO: delete Tracks from SoundCloud
					
					index = [indexes indexGreaterThanIndex:index];
				}
				[[tracksController content] removeObjectsAtIndexes:indexes];
				[tracksController rearrangeObjects];
				[uploadController checkTracksForUploadCompletion];
			}
			break;
			
		case 49: // space
			if (openRow == -1)
				[self openTrackAtRow:[self selectedRow]];
			break;
			
		case 53: // esc
			if (openRow >= 0)
				[self closeTrackAtRow:openRow];
			break;
		
		case 125: // up
		case 126: // down
			if (openRow >= 0)
				break;

		default:
			[super keyDown:theEvent];
			break;
	}
}


- (void)highlightSelectionInClipRect:(NSRect)clipRect {}


- (void)tableView:(NSTableView *)aTableView
  willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(NSInteger)rowIndex
{
	Track *track = [[tracksController arrangedObjects] objectAtIndex:rowIndex];
	NSView *statusView = [[track statusViewController] view];
	[(TrackCell *)aCell setStatusView:statusView];
	if (openRow == rowIndex)
		[statusView setHidden:YES];
	else
		[statusView setHidden:NO];
}

#pragma mark Actions

- (IBAction)selectTrack:(id)sender
{
	if ([self clickedRow] != openRow)
	{
		[self closeTrackAtRow:openRow];
	}
	
	[self noteHeightOfRowsWithIndexesChanged:
	 [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfRows])]];
}


- (IBAction)toggleTrack:(id)sender
{
	NSInteger row = [sender clickedRow];
	
	if (row != openRow)
		[self openTrackAtRow:row];
}


- (void)openTrackAtRow:(NSInteger)row
{
	openRow = row;
	NSRect frame = [trackEditView frame];
	NSRect cellFrame = [self frameOfCellAtColumn:0 row:row];
	frame.origin.x = 0;
	frame.origin.y = cellFrame.origin.y;
	frame.size.width = [self frame].size.width;
	frame.size.height = cellFrame.size.height;
	if (cellFrame.origin.y == 1.0)
	{
		frame.origin.y += 20.0;
		frame.size.height -= 20.0;
	}
	[trackEditView setFrame:frame];
	[self addSubview:trackEditView];
	[trackTitleLabel becomeFirstResponder];
	[self scrollRowToVisible:row];
	
	[self noteHeightOfRowsWithIndexesChanged:
	 [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfRows])]];
	
	[self scrollRowToVisible:openRow];
}


- (void)closeTrackAtRow:(NSInteger)row
{
	openRow = -1;
	if (openRowIsExpanded)
		[trackEditView toggleTrackDetailsView:self];
	[trackEditView removeFromSuperview];
	
	[self noteHeightOfRowsWithIndexesChanged:
	 [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfRows])]];
	
	[self scrollRowToVisible:openRow];
}

#pragma mark Accessor Methods

- (Boolean)openRowIsExpanded
{
	return openRowIsExpanded;
}

- (void)setOpenRowIsExpanded:(Boolean)isExpanded
{
	openRowIsExpanded = isExpanded;
	[self noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:openRow]];
}

#pragma mark Dragging Destination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if ([sender draggingSource] == self)
		return [super draggingEntered:sender];
	
	[self setNeedsDisplay:YES];
	return NSDragOperationCopy;
}

/*- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingExited:");
	[self setNeedsDisplay:YES];
}*/

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender
{
	[self setNeedsDisplay:YES];
	
	if ([sender draggingSource] == self)
		return [super draggingEntered:sender];
	
	return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	if ([sender draggingSource] == self)
		return [super prepareForDragOperation:sender];

	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	if ([sender draggingSource] == self)
		return [super performDragOperation:sender];
	
	NSPasteboard *pb = [sender draggingPasteboard];
	if(![self readFromPasteboard:pb])
	{
		NSLog(@"Error: Could not read from dragging pasteboard");
		return NO;
	}
	return YES;
}

/*- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	NSLog(@"concludeDragOperation:");
	[self reloadData];
	[self setNeedsDisplay:YES];
}*/

- (BOOL)readFromPasteboard:(NSPasteboard *)pb
{
	NSArray *types = [pb types];
	if ([types containsObject:NSFilenamesPboardType])
	{
		NSArray *filePaths = [pb propertyListForType:NSFilenamesPboardType];
		for (NSString *path in filePaths)
			NSLog(@"%@", path);
		
		[(NSMutableArray *)[tracksController content] addTracksWithFilenames:filePaths andParentSet:[uploadController set]];
		[tracksController didChangeArrangementCriteria];
		[uploadController uploadNextTrack];
		[uploadController checkTracksForUploadCompletion];
		return YES;
	}
	return NO;
}


@end
