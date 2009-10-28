//
//  TracksTableView.h
//  CloudPost
//
//  Created by Christian Stropp on 11.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TrackEditView;
@class CPUploadSetViewController;


@interface TracksTableView : NSTableView {
	IBOutlet CPUploadSetViewController *uploadController;
	IBOutlet NSArrayController *tracksController;
	IBOutlet TrackEditView *trackEditView;
	IBOutlet NSTextField *trackTitleLabel;
	NSInteger openRow;
	Boolean openRowIsExpanded;
}
@property (readonly) NSInteger openRow;

- (IBAction)selectTrack:(id)sender;
- (IBAction)toggleTrack:(id)sender;
- (void)openTrackAtRow:(NSInteger)row;
- (void)closeTrackAtRow:(NSInteger)row;

- (Boolean)openRowIsExpanded;
- (void)setOpenRowIsExpanded:(Boolean)isExpanded;

- (BOOL)readFromPasteboard:(NSPasteboard *)pb;

@end
