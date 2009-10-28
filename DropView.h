//
//  DropView.h
//  CloudPost
//
//  Created by Christian Stropp on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPTrackPostWindowController.h"


@interface DropView : NSView {
	BOOL highlighted;
	
	IBOutlet CPTrackPostWindowController *windowController;
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb;

@end
