//
//  GrayLine.m
//  CloudPost
//
//  Created by Christian Stropp on 24.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BluishLine.h"


@implementation BluishLine

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[NSColor colorWithDeviceRed:0.890625
												 green:0.8984375
												  blue:0.9140625
												 alpha:1.0]];
    }
    return self;
}

@end
