//
//  NSMutableArray-Tracks.h
//  CloudPost
//
//  Created by Christian Stropp on 31.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Set.h"


@interface NSMutableArray (Tracks)

- (BOOL)addTrackWithFilename:(NSString *)filename andParentSet:(Set *)parentSet;
- (NSArray *)addTracksWithFilenames:(NSArray *)filenames andParentSet:(Set *)parentSet;

@end
