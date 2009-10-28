//
//  StyledWindow.h
//
//  Created by Jeff Ganyard on 11/3/06.
//  rev 2: 11/15/06 - now supports toolbars properly
/*
	Copyright (c) 2006 Bithaus.

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	Sending an email to ganyard (at) bithaus.com informing where the code is being used would be appreciated.
*/

#import <Cocoa/Cocoa.h>


@interface StyledWindow : NSWindow
{
	BOOL forceDisplay;

	float topBorder;
	float bottomBorder;
	float titleBarHeight;
	
	NSColor *borderStartColor;
	NSColor *borderEndColor;
	NSColor *borderEdgeColor;

	NSColor *bgColor;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag;

- (NSColor *)styledBackground;

- (BOOL)forceDisplay;
- (void)setForceDisplay:(BOOL)flag;

- (float)topBorder;
- (void)setTopBorder:(float)newTopBorder;

- (float)bottomBorder;
- (void)setBottomBorder:(float)newBottomBorder;

- (NSColor *)borderStartColor;
- (void)setBorderStartColor:(NSColor *)newBorderStartColor;

- (NSColor *)borderEndColor;
- (void)setBorderEndColor:(NSColor *)newBorderEndColor;

- (NSColor *)borderEdgeColor;
- (void)setBorderEdgeColor:(NSColor *)newBorderEdgeColor;

- (NSColor *)bgColor;
- (void)setBgColor:(NSColor *)newBgColor;

@end
