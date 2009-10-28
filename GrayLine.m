//
//  GrayLine.m
//  CloudPost
//
//  Created by Christian Stropp on 27.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GrayLine.h"


@implementation GrayLine

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[NSColor colorWithDeviceWhite:0.44140625
												   alpha:1.0]];
    }
    return self;
}

@end
