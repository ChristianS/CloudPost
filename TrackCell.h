//
//  TrackCell.h
//  CloudPost
//
//  Created by Christian Stropp on 11.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TrackCell : NSTextFieldCell {
	NSView *statusView;
}
@property (nonatomic, retain) NSView *statusView;

@end
