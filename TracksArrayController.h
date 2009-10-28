//
//  TracksArrayController.h
//  CloudPost
//
//  Created by Christian Stropp on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TracksTableView.h"


@interface TracksArrayController : NSArrayController {
	IBOutlet NSViewController *viewController;
	IBOutlet TracksTableView *tracksTable;
}

@end
