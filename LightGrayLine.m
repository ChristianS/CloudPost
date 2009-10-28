//
//  LightGrayLine.m
//  CloudPost
//
//  Created by Christian Stropp on 17.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LightGrayLine.h"


@implementation LightGrayLine

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[NSColor colorWithDeviceWhite:0.9
														 alpha:1.0]];
    }
    return self;
}

@end
