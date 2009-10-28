//
//  DarkGrayLine.m
//  CloudPost
//
//  Created by Christian Stropp on 29.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DarkGrayLine.h"


@implementation DarkGrayLine

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[NSColor colorWithDeviceWhite:0.19140625
												 alpha:1.0]];
    }
    return self;
}

@end
