//
//  TracksArrayController.m
//  CloudPost
//
//  Created by Christian Stropp on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TracksArrayController.h"

#define TrackDataType @"NSMutableDictionary"


@implementation TracksArrayController

- (void)awakeFromNib
{
	[tracksTable registerForDraggedTypes:[NSArray arrayWithObject:TrackDataType]];
	[tracksTable setDataSource:self];
	[tracksTable setDraggingSourceOperationMask:(NSDragOperationMove | NSDragOperationCopy) forLocal:YES];
}

#pragma mark NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)aTableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard *)pboard
{
	// Copy the row numbers to the pasteboard.
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	
	[pboard declareTypes:[NSArray arrayWithObject:TrackDataType] owner:self];
	
	[pboard setData:data forType:TrackDataType];
	
	[tracksTable selectRowIndexes:rowIndexes byExtendingSelection:NO];
	
	return YES;
}


- (NSDragOperation)tableView:(NSTableView *)aTableView
				validateDrop:(id < NSDraggingInfo >)info
				 proposedRow:(NSInteger)row
	   proposedDropOperation:(NSTableViewDropOperation)operation
{
	if (operation != NSTableViewDropAbove)
		return NSDragOperationNone;
	
	return operation;
}


- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id < NSDraggingInfo >)info
			  row:(NSInteger)row
	dropOperation:(NSTableViewDropOperation)operation
{	
	NSPasteboard* pboard = [info draggingPasteboard];
	NSData* rowData = [pboard dataForType:TrackDataType];
	
	NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	
	NSMutableArray *allItemsArray = [NSMutableArray arrayWithArray:[self arrangedObjects]];
	
	NSMutableArray *draggedItemsArray = [NSMutableArray arrayWithCapacity:[rowIndexes count]];
	
	NSUInteger currentItemIndex;
	NSRange range = NSMakeRange(0, [rowIndexes lastIndex] + 1);
	while([rowIndexes getIndexes:&currentItemIndex maxCount:1 inIndexRange:&range] > 0)
	{
        NSManagedObject *thisItem = [allItemsArray objectAtIndex:currentItemIndex];
        [draggedItemsArray addObject:thisItem];
        [allItemsArray replaceObjectAtIndex:currentItemIndex withObject:[NSNull null]];
	}
	
	for (NSMutableDictionary *track in [draggedItemsArray reverseObjectEnumerator])
	{
        [allItemsArray insertObject:track atIndex:row];
	}
	[allItemsArray removeObject:[NSNull null]];
	[self setContent:allItemsArray];
	
	return YES;
}

@end
