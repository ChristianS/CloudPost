//
//  CPTrackPostWindowController.m
//  CloudPost
//
//  Created by Ullrich Schäfer on 11.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPTrackPostWindowController.h"
#import "CloudPostAppDelegate.h"
#import "StyledWindow.h"
#import "CPUploadSetViewController.h"
#import "CPStatusViewController.h"
#import "NSAttributedString-Hyperlink.h"
#import "CPConstants.h"
#import "OAuthKeys.h"

@implementation CPTrackPostWindowController

#pragma mark Accessors
@synthesize oAuthURL;
@synthesize hasAPIConnection;
@synthesize apiController;
@synthesize tracks;

- (id)initWithWindowNibName:(NSString *)windowNibName;
{
	if (self = [super initWithWindowNibName:windowNibName])
	{
		if ([[NSUserDefaults standardUserDefaults] boolForKey:CPSandboxModeKey])
		{
			scApiConfig = [[SCSoundCloudAPIConfiguration alloc]
						   initForSandboxWithConsumerKey:kCPSoundCloudSandboxConsumerKey
											consumerSecret:kCPSoundCloudSandboxConsumerSecret
												callbackURL:[NSURL URLWithString:@"x-cloudpost://backFromOAuth"]];
		}
		else
		{
			scApiConfig = [[SCSoundCloudAPIConfiguration alloc]
						   initForProductionWithConsumerKey:kCPSoundCloudProductionConsumerKey
												consumerSecret:kCPSoundCloudProductionConsumerSecret
													callbackURL:[NSURL URLWithString:@"x-cloudpost://backFromOAuth"]];
		}
		
		apiController = [[CPSoundcloudAPIController alloc] initWithAuthenticationDelegate:self];
		
		StyledWindow *styledWindow = (StyledWindow *) [self window];
		
		// style window
		[styledWindow setBorderStartColor:[NSColor colorWithDeviceWhite:0.8 alpha:1.0]];
		[styledWindow setBorderEndColor:[NSColor colorWithDeviceWhite:0.65 alpha:1.0]];
		[styledWindow setBorderEdgeColor:[NSColor colorWithDeviceWhite:0.25 alpha:1.0]];
		[styledWindow setBgColor:[NSColor whiteColor]];
		[styledWindow setTopBorder:22.0];
		[styledWindow setBottomBorder:30.0];
		[styledWindow setBackgroundColor:[styledWindow styledBackground]];
		
		// make window not resizable
		[styledWindow setMinSize:[styledWindow frame].size];
		[styledWindow setMaxSize:[styledWindow frame].size];
		[styledWindow setShowsResizeIndicator:NO];
		
		tracks = [[NSMutableArray alloc] init];
		set = [[Set alloc] init];
	}
	return self;
}

- (void)awakeFromNib
{
	[urlLabel setAllowsEditingTextAttributes:YES];
	[urlLabel setSelectable:YES];
}

- (void)dealloc;
{
	[set release];
	[tracks release];
	[apiController release];
	[scApiConfig release];
	[super dealloc];
}

#pragma mark Actions

- (void)openDroppedFiles:(NSArray *)filePaths
{
	[activityIndicator setHidden:NO];
	[activityIndicator startAnimation:self];
	
	NSArray *validFilePaths = [tracks addTracksWithFilenames:filePaths andParentSet:set];
	
	[activityIndicator stopAnimation:self];
	[activityIndicator setHidden:YES];
	
	// TODO: error message for not loaded files in invalidFilePaths?
	
	if (validFilePaths.count < 1) //TODO: show error in drop view
	{
		NSLog(@"No audio files were dropped");
	}
	/*else if (validFilePaths.count == 1) //TODO: show single track edit view
	{
		NSLog(@"Exactly one audio file was dropped");
		NSRect viewFrame = [styledWindowContentView frame];
		viewFrame.origin = NSMakePoint(0.0, 0.0);
		//[trackView setFrame:viewFrame];
		//[styledWindowContentView addSubview:trackView];
	}*/
	else // show set edit view
	{
		NSLog(@"Multiple audio files were dropped");
		
		StyledWindow *styledWindow = (StyledWindow *) [self window];
		
		[dropView removeFromSuperview];
		
		// set window size
		NSRect frame = [styledWindow frame];
		NSSize newSize = NSMakeSize(670.0, 520.0);
		frame.origin.y -= newSize.height - frame.size.height;
		frame.size = newSize;
		[styledWindow setFrame:frame display:YES animate:YES];
		
		// make window not resizable
		[styledWindow setMinSize:NSMakeSize(660.0, 500.0)]; //TODO: calc min size
		[styledWindow setMaxSize:NSMakeSize(9999.0, 9999.0)];
		[styledWindow setShowsResizeIndicator:YES];
		
		NSRect viewFrame = [styledWindowContentView frame];
		viewFrame.origin = NSMakePoint(0.0, 0.0);
		uploadController = [[CPUploadSetViewController alloc] initWithTracks:tracks andSet:set];
		[uploadController setDelegate:self];
		
		NSView *setView = [uploadController view];
		[setView setFrame:viewFrame];
		[sendButton setTarget:uploadController];
		[sendButton setAction:@selector(send)];
		[addButton setTarget:uploadController];
		[addButton setAction:@selector(addFiles)];
		[styledWindowContentView addSubview:setView];
		[styledWindowContentView setNextKeyView:setView];
	}
}


- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	// Get the URL
	NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
	
	if([urlStr hasPrefix:@"x-cloudpost"])
	{
		NSLog(@"handling oauth callback");
		[apiController.api authorizeRequestToken];
	}
}


- (IBAction)authorize:(id)sender
{
	if (oAuthURL)
	{
		[[NSWorkspace sharedWorkspace] openURL:oAuthURL];
		
		[[[self window] contentView] addSubview:completeAuthView];
		[authView removeFromSuperview];
	}
}


- (IBAction)completeAuthorization:(id)sender
{
	[apiController.api authorizeRequestToken];
}


- (IBAction)showDropView:(id)sender
{
	[authView removeFromSuperview];
	[completeAuthView removeFromSuperview];
	[successView removeFromSuperview];
	
	[[[self window] contentView] addSubview:dropView];
}


- (IBAction)cancel:(id)sender
{
	NSWindow *window = [self window];
	[[uploadController view] removeFromSuperview];
	
	// set window size
	NSRect frame = [window frame];
	NSSize newSize = NSMakeSize(390.0, 310.0);
	frame.origin.y -= newSize.height - frame.size.height;
	frame.size = newSize;
	[window setFrame:frame display:YES animate:YES];
	
	// make window not resizable
	[window setMinSize:[window frame].size];
	[window setMaxSize:[window frame].size];
	[window setShowsResizeIndicator:NO];
	
	[self showDropView:self];
	[uploadController release];
	
	[tracks release];
	[set release];
	tracks = [[NSMutableArray alloc] init];
	set = [[Set alloc] init];
}

#pragma mark UploadController Delegate

- (void)uploadControllerBeganUploading:(id)uploadController
{
	[sendButton setEnabled:NO];
}


- (void)uploadControllerFinishedUploading:(id)uploadController
{
	[sendButton setEnabled:YES];
}


- (void)uploadController:(id)uploadController endedWithRessourceURL:(NSURL *)ressourceUrl;
{
	[self cancel:self];
	
	if (ressourceUrl)
	{
		// show success screen
		[[[self window] contentView] addSubview:successView];
		
		NSMutableAttributedString* urlString = [[NSMutableAttributedString alloc] init];
		[urlString appendAttributedString:
		 [NSAttributedString hyperlinkFromString:[ressourceUrl description] withURL:ressourceUrl]];
		
		// set alignment to center
		NSRange range = NSMakeRange(0, [urlString length]);
		[urlString beginEditing];
		NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
		[para setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
		[para setAlignment:NSCenterTextAlignment];
		[urlString addAttribute:NSParagraphStyleAttributeName value:para range:range];
		[urlString endEditing];
		
		[urlLabel setAttributedStringValue: urlString];
	}
}

#pragma mark SCSoundCloudAPIAuthenticationDelegate

- (SCSoundCloudAPIConfiguration *)configurationForSoundCloudAPI:(SCSoundCloudAPI *)scAPI
{
	return scApiConfig;
}


- (void)soundCloudAPI:(SCSoundCloudAPI *)scAPI requestedAuthenticationWithURL:(NSURL *)authURL
{
	self.oAuthURL = authURL;
	[self.window.contentView addSubview:authView];
}


- (void)soundCloudAPI:(SCSoundCloudAPI *)scAPI didChangeAuthenticationStatus:(SCAuthenticationStatus)status
{
	if (status == SCAuthenticationStatusAuthenticated)
	{
		[self willChangeValueForKey:@"hasAPIConnection"];
		hasAPIConnection = YES;
		[self didChangeValueForKey:@"hasAPIConnection"];
		
		[self showDropView:self];
	}
	else
		[apiController.api requestAuthentication];
}


- (void)soundCloudAPI:(SCSoundCloudAPI *)scAPI didEncounterError:(NSError *)error
{
	[[NSApplication sharedApplication] presentError:error];
	
	if ([[error domain] isEqualToString:SCAPIErrorDomain]) {
		if ([error code] == SCAPIErrorHttpResponseError) {
			NSError *httpError = [[error userInfo] objectForKey:SCAPIHttpResponseErrorStatusKey];
			if (httpError.code == NSURLErrorNotConnectedToInternet) {
				// inform the user and offer him to retry
			}
		} else if ([error code] == SCAPIErrorNotAuthenticted) {
			
		}
	}
}

#pragma mark Window Delegate Methods

- (void)windowDidResignMain:(NSNotification *)notification
{
	StyledWindow *styledWindow = (StyledWindow *) [self window];
	[styledWindow setBorderStartColor:[NSColor colorWithDeviceWhite:0.92 alpha:1.0]];
	[styledWindow setBorderEndColor:[NSColor colorWithDeviceWhite:0.83 alpha:1.0]];
	[styledWindow setBorderEdgeColor:[NSColor colorWithDeviceWhite:0.35 alpha:1.0]];
	[styledWindow setBackgroundColor:[styledWindow styledBackground]];
}


- (void)windowDidBecomeMain:(NSNotification *)notification
{
	StyledWindow *styledWindow = (StyledWindow *) [self window];
	[styledWindow setBorderStartColor:[NSColor colorWithDeviceWhite:0.8 alpha:1.0]];
	[styledWindow setBorderEndColor:[NSColor colorWithDeviceWhite:0.65 alpha:1.0]];
	[styledWindow setBorderEdgeColor:[NSColor colorWithDeviceWhite:0.25 alpha:1.0]];
	[styledWindow setBackgroundColor:[styledWindow styledBackground]];
}

@end
