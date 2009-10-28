//
//  CloudPostAppDelegate.h
//  CloudPost
//
//  Created by Ullrich Schäfer on 11.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPTrackPostWindowController.h"

#define appDelegate			((CloudPostAppDelegate *)[[NSApplication sharedApplication] delegate])

@interface CloudPostAppDelegate : NSObject {
	CPTrackPostWindowController *trackPostWindowController;
}

@end
