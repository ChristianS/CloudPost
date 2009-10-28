//
//  NSMutableArray-Tracks.m
//  CloudPost
//
//  Created by Christian Stropp on 31.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray-Tracks.h"
#import "CPStatusViewController.h"
#import "Track.h"


@implementation NSMutableArray (Tracks)

- (BOOL)addTrackWithFilename:(NSString *)filename andParentSet:(Set *)parentSet
{
	// allow AIFF, WAVE, FLAC, OGG, MP3, AAC
	NSSet * const validExtensions = [[NSSet alloc] initWithObjects:
						   @"aif", @"aiff", @"wav", @"flac", @"ogg", @"oga",
						   @"mp3", @"aac", @"m4a", nil];
	
	if ([validExtensions containsObject:[filename pathExtension]])
	{
		NSURL *fileURL = [NSURL fileURLWithPath:filename];
		if (fileURL != nil)
		{
			Track *track = [[Track alloc] initWithFileURL:fileURL andSet:parentSet];
			[self addObject:track];
			[track release];
		}
		
		return YES;
	}
	
	return NO;
}


- (NSArray *)addTracksWithFilenames:(NSArray *)filenames andParentSet:(Set *)parentSet
{
	NSSet *bundleExtensions = [[NSSet alloc] initWithObjects:@"band", @"app", nil];
	
	NSMutableArray *validFilenames = [[NSMutableArray alloc] init];
	[validFilenames autorelease];
	
	for (NSString *filename in filenames)
	{
		// gather files from directories
		if ([[filename pathExtension] isEqualToString:@""])
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:filename];
			NSString *pname;
			while (pname = [dirEnum nextObject])
			{
				if (![bundleExtensions containsObject:[pname pathExtension]])
				{
					if ([self addTrackWithFilename:[filename stringByAppendingPathComponent:pname]
									  andParentSet:parentSet])
						[validFilenames addObject:[filename stringByAppendingPathComponent:pname]];
				}	
				else
					[dirEnum skipDescendents];
			}
			
		}
		// process files
		else if ([self addTrackWithFilename:filename andParentSet:parentSet])
			[validFilenames addObject:filename];
	}
	
	[bundleExtensions release];
	return validFilenames;
}

@end
