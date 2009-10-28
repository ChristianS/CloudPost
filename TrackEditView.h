//
//  TrackEditView.h
//  CloudPost
//
//  Created by Christian Stropp on 17.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TracksTableView;


@interface TrackEditView : NSView {
	IBOutlet NSArrayController *controller;
	IBOutlet TracksTableView *tracksTable;
	IBOutlet NSView *trackDetailsView;
	
	IBOutlet NSTextField *genre;
	IBOutlet NSPopUpButton *type;
	IBOutlet NSPopUpButton *license;
	IBOutlet NSPopUpButton *releaseDateYear;
	IBOutlet NSPopUpButton *releaseDateMonth;
	IBOutlet NSPopUpButton *releaseDateDay;
}

- (IBAction)toggleTrackDetailsView:(id)sender;

@end
