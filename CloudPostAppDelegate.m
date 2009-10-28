//
//  CloudPostAppDelegate.m
//  CloudPost
//
//  Created by Ullrich Schäfer on 11.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CloudPostAppDelegate.h"
#import "CPSoundcloudAPIController.h"
#import "CPConstants.h"


@interface CloudPostAppDelegate (Private)
- (void)_registerMyApp;
@end


@implementation CloudPostAppDelegate

#pragma mark Lifecycle

+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:CPSandboxModeKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	trackPostWindowController = [[CPTrackPostWindowController alloc] initWithWindowNibName:@"TrackPostWindow"];
	[trackPostWindowController showWindow:self];
	
	[self _registerMyApp];
}

- (void)dealloc;
{
	[trackPostWindowController release];
	[super dealloc];
}

#pragma mark URL handling

- (void)_registerMyApp;
{
	NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
	[em setEventHandler:trackPostWindowController 
			andSelector:@selector(getUrl:withReplyEvent:) 
		  forEventClass:kInternetEventClass 
			 andEventID:kAEGetURL];
	
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	OSStatus result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"x-cloudpost", (CFStringRef)bundleID);
	if(result != noErr) {
		NSLog(@"could not register to \"x-cloudpost\" URL scheme");
	}
}

#pragma mark NSApplicationDelegate
/*- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path;
{
	return [[trackPostWindowController tracks] addTrackWithFilename:path andParentSet:set];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames;
{
	[[trackPostWindowController tracks] addTracksWithFilenames:filenames andParentSet:set];
}*/

@end
