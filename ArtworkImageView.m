//
//  ArtworkImageView.m
//  CloudPost
//
//  Created by Christian Stropp on 06.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ArtworkImageView.h"


@implementation ArtworkImageView


#pragma mark NSControl methods

- (void)mouseDown:(NSEvent *)theEvent { } // needed for mouseUp: to be fired


- (void)mouseUp:(NSEvent *)theEvent
{
	SEL selector = @selector(showPictureTaker:);
	if ([theEvent clickCount] == 2 && [showPictureTakerTarget respondsToSelector:selector])
		[self sendAction:selector to:showPictureTakerTarget];
}

@end
