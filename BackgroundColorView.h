//
//  BackgroundColorView.h
//  CloudPost
//
//  Created by Christian Stropp on 29.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BackgroundColorView : NSView {
	NSColor *backgroundColor;
}
@property (nonatomic, retain) NSColor *backgroundColor;

@end
