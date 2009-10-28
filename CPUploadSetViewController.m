//
//  CPUploadSetViewController.m
//  CloudPost
//
//  Created by Christian Stropp on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "CPUploadSetViewController.h"
#import "CloudPostAppDelegate.h"
#import "CPStatusViewController.h"
#import "JSON/JSON.h"


@implementation CPUploadSetViewController

@synthesize delegate;
@synthesize set;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		setDetailsVisible = YES;
		inviteViewVisible = YES;
		isSetEditable = YES;
		
		years = [[NSMutableArray alloc] init];
		[years addObject:@"YYYY"];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		int thisYear = [[gregorian components:NSYearCalendarUnit fromDate:[NSDate date]] year];
		for (int year = thisYear + 2; year >= 1950; --year)
			[years addObject:[NSString stringWithFormat:@"%d", year]];
		[gregorian release];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myWindowDidResize:) name:@"NSWindowDidResizeNotification" object:nil];
		
		playlistTypeNames = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"album", @"1",
						  @"compilation", @"2",
						  @"demo", @"3",
						  @"ep", @"4",
						  @"playlist", @"5",
						  @"showcase", @"6",
						  @"single", @"7", nil];
		
		trackTypeNames = [[NSDictionary alloc] initWithObjectsAndKeys:
						  @"original", @"1",
						  @"in progress", @"2",
						  @"reedit", @"3",
						  @"djset", @"4",
						  @"live", @"5",
						  @"cover", @"6",
						  @"mashup", @"7",
						  @"podcast", @"8",
						  @"sample", @"9",
						  @"demo", @"10",
						  @"remix", @"11",
						  @"part", @"12", nil];
		
		licenseNames = [[NSDictionary alloc] initWithObjectsAndKeys:
						@"all-rights-reserved", @"0",
						@"no-rights-reserved", @"1",
						@"cc-by", @"2",
						@"cc-by-nc", @"3",
						@"cc-by-nc-nd", @"4",
						@"cc-by-nc-sa", @"5",
						@"cc-by-sa", @"6",
						@"cc-by-nd", @"7", nil];
	}
	return self;
}

- (void)awakeFromNib
{
	// set view background colors
	[tracksView setBackgroundColor:[NSColor colorWithDeviceRed:0.78125 green:0.78125 blue:0.78125 alpha:1.0]];
	
	[inviteView setBackgroundColor:[NSColor colorWithDeviceRed:0.52734375 green:0.52734375 blue:0.52734375 alpha:1.0]];
	[bottomControlsView setBackgroundColor:[NSColor colorWithDeviceRed:0.52734375 green:0.52734375 blue:0.52734375 alpha:1.0]];
	
	[setDetailsView setBackgroundColor:[NSColor colorWithDeviceRed:0.921875 green:0.9453125 blue:0.9765625 alpha:1.0]];
	[setView setBackgroundColor:[NSColor colorWithDeviceRed:0.921875 green:0.9453125 blue:0.9765625 alpha:1.0]];

	// hide disclosure views
	[self hideSetDetailsAndInvitView];
	
	// set white button titles
	NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:
						  [NSColor whiteColor], NSForegroundColorAttributeName,
						  [downloadable font], NSFontAttributeName, nil];
	
	NSAttributedString *atted = [[NSAttributedString alloc] initWithString:[downloadable title] attributes:dict];
	[downloadable setAttributedTitle:atted];
	[atted release];
	
	atted = [[NSAttributedString alloc] initWithString:[streaming title] attributes:dict];
	[streaming setAttributedTitle:atted];
	[atted release];
	
	// set gray title for placeholder in popupbutton menu item
	NSDictionary *style = [NSDictionary  dictionaryWithObjectsAndKeys:
						  [NSColor grayColor], NSForegroundColorAttributeName,
						  [type font], NSFontAttributeName, nil];
	NSMenuItem *item = [type itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateYear itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateMonth itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	item = [releaseDateDay itemAtIndex:0];
	atted = [[NSAttributedString alloc] initWithString:[item title] attributes:style];
	[item setAttributedTitle:atted];
	[atted release];
	
	// menu item images
	NSMenuItem *ccItem;
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:2]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:3]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:4]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC-ND"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:5]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-NC-SA"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:6]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-SA"]];
	ccItem = [license itemAtIndex:[license indexOfItemWithTag:7]];
	[ccItem setImage:[NSImage imageNamed:@"CC-BY-ND"]];
	
	[self performSelector:@selector(uploadNextTrack) withObject:self afterDelay:1.0];
	[delegate uploadControllerBeganUploading:self];
}


- (void)dealloc
{
	[playlistTypeNames release];
	[trackTypeNames release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark Actions

- (void)hideSetDetailsAndInvitView
{
	// hide set details
	// hide invite view
	// resize track view correctly
	
	NSRect detailsFrame = [setDetailsView frame];
	NSRect tracksFrame = [tracksView frame];
	float detailsHeight = detailsFrame.size.height;
	
	NSRect frame = [bottomControlsView frame];
	NSRect inviteViewFrame = [inviteView frame];
	float inviteHeight = inviteViewFrame.size.height;
	
	setDetailsVisible = NO;
	[setDetailsView setHidden:YES];
	
	inviteViewVisible = NO;
	[inviteView setHidden:YES];
	
	detailsFrame.size.height = 0;
	detailsFrame.origin.y += detailsHeight;
	tracksFrame.size.height += detailsHeight;
	
	frame.origin.y -= inviteHeight;
	tracksFrame.origin.y -= inviteHeight;
	tracksFrame.size.height += inviteHeight;
	
	[tracksView setFrame:tracksFrame];
	[setDetailsView setFrame:detailsFrame];
	[bottomControlsView setFrame:frame];
}

/* mixed toggleSetDetails & toggleInviteView for simultaneous animation
 * -> not very elegant / duplicate code
 */
- (void)toggleSetDetailsAndInviteView
{
	NSRect detailsFrame = [setDetailsView frame];
	NSRect tracksFrame = [tracksView frame];
	float detailsHeight = 127.0; // frame.size.height;
	
	NSRect frame = [bottomControlsView frame];
	NSRect inviteViewFrame = [inviteView frame];
	float inviteHeight = 93.0; // inviteViewFrame.size.height;
	
	if (setDetailsVisible)
	{
		setDetailsVisible = NO;
		[self performSelector:@selector(hideView:) withObject:setDetailsView afterDelay:0.5];
		detailsFrame.size.height = 0;
		detailsFrame.origin.y += detailsHeight;
		
		tracksFrame.size.height += detailsHeight;
		
		inviteViewVisible = YES;
		[inviteView setHidden:NO];
		inviteViewFrame.size.height = inviteHeight;
		
		frame.origin.y += inviteHeight;
		tracksFrame.origin.y += inviteHeight;
		tracksFrame.size.height -= inviteHeight;
	}
	else
	{
		setDetailsVisible = YES;
		[setDetailsView setHidden:NO];
		detailsFrame.size.height = detailsHeight;
		detailsFrame.origin.y -= detailsHeight;
		
		tracksFrame.size.height -= detailsHeight;
		
		[[[self view] window] makeFirstResponder:genre];
		
		inviteViewVisible = NO;
		[self performSelector:@selector(hideView:) withObject:inviteView afterDelay:0.5];
		inviteViewFrame.size.height = 0.0;
		
		frame.origin.y -= inviteHeight;
		tracksFrame.origin.y -= inviteHeight;
		tracksFrame.size.height += inviteHeight;
	}
	[[tracksView animator] setFrame:tracksFrame];
	[[setDetailsView animator] setFrame:detailsFrame];
	[[bottomControlsView animator] setFrame:frame];
}


- (IBAction)toggleSetDetails:(id)sender
{
	NSRect frame = [setDetailsView frame];
	NSRect tracksFrame = [tracksView frame];
	float height = 127.0; // frame.size.height;
	
	if (setDetailsVisible)
	{
		setDetailsVisible = NO;
		[self performSelector:@selector(hideView:) withObject:setDetailsView afterDelay:0.3];
		frame.size.height = 0;
		frame.origin.y += height;
		
		tracksFrame.size.height += height;
	}
	else
	{
		setDetailsVisible = YES;
		[setDetailsView setHidden:NO];
		frame.size.height = height;
		frame.origin.y -= height;
		
		tracksFrame.size.height -= height;
		
		[[[self view] window] makeFirstResponder:genre];
	}
	[[tracksView animator] setFrame:tracksFrame];
	[[setDetailsView animator] setFrame:frame];
}


- (void)toggleInviteView
{
	NSRect frame = [bottomControlsView frame];
	NSRect inviteViewFrame = [inviteView frame];
	float height = 93.0; // inviteViewFrame.size.height;
	NSRect tracksFrame = [tracksView frame];
	
	if (inviteViewVisible)
	{
		inviteViewVisible = NO;
		[self performSelector:@selector(hideView:) withObject:inviteView afterDelay:0.3];
		inviteViewFrame.size.height = 0.0;
		
		frame.origin.y -= height;
		tracksFrame.origin.y -= height;
		tracksFrame.size.height += height;
	}
	else
	{
		inviteViewVisible = YES;
		[inviteView setHidden:NO];
		inviteViewFrame.size.height = height;
		
		frame.origin.y += height;
		tracksFrame.origin.y += height;
		tracksFrame.size.height -= height;
	}
	[[bottomControlsView animator] setFrame:frame];
	[[tracksView animator] setFrame:tracksFrame];
}


- (IBAction)sharingChanged:(id)sender
{
	if ([sharing indexOfSelectedItem] == 0 && inviteViewVisible)
	{
		[self toggleInviteView];
		[publicLabel setHidden:NO];
		[privateLabel setHidden:YES];
	}
	else if ([sharing indexOfSelectedItem] == 1 && !inviteViewVisible)
	{
		if (setDetailsVisible)
			[self toggleSetDetailsAndInviteView];
		else
			[self toggleInviteView];
		[publicLabel setHidden:YES];
		[privateLabel setHidden:NO];
		[invited becomeFirstResponder];
	}
}


- (void)hideView:(NSView *)view { [view setHidden:YES]; }


- (void)uploadNextTrack
{
	Boolean foundTrack = NO;
	
	for (Track *track in [tracksController arrangedObjects])
		if (!foundTrack && track.uploadStatus == kUploadStatusLocal)
		{
			NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
			
			[parameters setObject:[track objectForKey:@"asset_data"] forKey:@"track[asset_data]"];
			[parameters setObject:[track objectForKey:@"title"] forKey:@"track[title]"];
			[parameters setObject:@"false" forKey:@"track[sharing]"];
			[parameters setObject:@"false" forKey:@"track[downloadable]"];
			[parameters setObject:@"false" forKey:@"track[streamable]"];
			
			track.uploadStatus = kUploadStatusUploading;
			
			[[delegate apiController] postTrackWithParameters:parameters
														 context:track
											  requestDelegate:self];
			foundTrack = YES;
		}
	
	if (!foundTrack)
		[self checkTracksForUploadCompletion];
}


- (void)updateTracks
{
	for (Track *track in [tracksController arrangedObjects])
		if (track.uploadStatus == kUploadStatusUploaded)
		{
			NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
			NSDictionary *trackDict = [track mergedDictionary];
			
			for (NSString *key in trackDict)
				if (![key isEqualToString:@"asset_data"])
				{
					NSString *enclosedKey = [NSString stringWithFormat:@"track[%@]", key];
					[parameters setObject:[[trackDict objectForKey:key] description] forKey:enclosedKey];
				}
			
			// transform multiple-values fields' values
			NSNumber* selected;
			selected = [parameters objectForKey:@"track[track_type]"];
			if (selected > 0)
				[parameters setObject:[trackTypeNames objectForKey:[selected description]] forKey:@"track[track_type]"];
			selected = [parameters objectForKey:@"track[release_year]"];
			if (selected > 0)
				[parameters setObject:[years objectAtIndex:[selected intValue]] forKey:@"track[release_year]"];
			
			selected = [parameters objectForKey:@"track[license]"];
			if (selected == nil)
				selected = @"0";
			[parameters setObject:[licenseNames objectForKey:selected] forKey:@"track[license]"];
			
			// parameters from the set
			[parameters setObject:([sharing selectedTag] == 0) ? @"public" : @"private" forKey:@"track[sharing]"];
			[parameters setObject:[downloadable state] == NSOnState ? @"true": @"false" forKey:@"track[downloadable]"];
			[parameters setObject:[streaming state] == NSOnState ? @"true": @"false" forKey:@"track[streamable]"];
			
			if ([artwork image])
				[parameters setObject:(NSData *)[[artwork image] TIFFRepresentation] forKey:@"track[artwork_data]"];
			
			track.uploadStatus = kUploadStatusUpdating;
			
			[[delegate apiController] putTrackWithParameters:parameters
														context:track
												requestDelegate:self];
		}
}


- (void)checkTracksForUploadCompletion
{
	Boolean isComplete = YES;
	Boolean someFailed = NO;
	Boolean allFailed = YES;
	
	if ([[tracksController arrangedObjects] count] == 0)
		isComplete = NO;
	else
		for (Track *track in [tracksController arrangedObjects])
			if (track.uploadStatus < kUploadStatusUploaded)
			{
				isComplete = NO;
				if (track.uploadStatus == kUploadStatusFailedUploading)
					someFailed = YES;
			}
			else 
				allFailed = NO;
	
	if (isComplete || (!isComplete && !allFailed))
		[delegate uploadControllerFinishedUploading:self];
	else
		[delegate uploadControllerBeganUploading:self];
	
	if (someFailed)
		[self performSelector:@selector(retryFailedTracks) withObject:self afterDelay:10.0];
}


- (void)retryFailedTracks
{
	for (Track *track in [tracksController arrangedObjects])
		if (track.uploadStatus == kUploadStatusFailedUploading)
			track.uploadStatus = kUploadStatusLocal;
	
	[self uploadNextTrack];
}


#pragma mark UploadController Actions

- (id)initWithTracks:(NSMutableArray *)newTracks andSet:(Set *)newSet
{
	if (self = [self initWithNibName:@"UploadSetView" bundle:nil])
	{
		tracks = newTracks;
		self.set = newSet;
		
		// set defaults for the Set
		[set setObject:@"New Set" forKey:@"title"];
		
		// observe button content to resize button to content size
		[[set setDict] addObserver:self forKeyPath:@"playlist_type" options:0 context:nil];
		[[set setDict] addObserver:self forKeyPath:@"license" options:0 context:nil];
	}
	return self;
}


- (void)send
{
	[delegate uploadControllerBeganUploading:self];
	
	NSRect frame = [overlay frame];
	frame.origin.x = (self.view.frame.size.width / 2) - (frame.size.width / 2);
	frame.origin.y = (self.view.frame.size.height / 2) - (frame.size.height / 2);
	[overlay setFrame:frame];
	[[self view] addSubview:overlay];
	[overlay becomeFirstResponder];
	
	[self updateTracks];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	NSDictionary *setDict = [set setDict];
	
	for (NSString *key in setDict)
	{
		NSString *enclosedKey = [NSString stringWithFormat:@"playlist[%@]", key];
		[parameters setObject:[[setDict objectForKey:key] description] forKey:enclosedKey];
	}
	
	// transform multiple-values fields' values
	NSString* selected;
	selected = [parameters objectForKey:@"playlist[playlist_type]"];
	if ([selected intValue] > 0)
		[parameters setObject:[playlistTypeNames objectForKey:selected] forKey:@"playlist[playlist_type]"];
	else
		[parameters removeObjectForKey:@"playlist[playlist_type]"];
	
	selected = [parameters objectForKey:@"playlist[release_year]"];
	if ([selected intValue] > 0)
		[parameters setObject:[years objectAtIndex:[selected intValue]] forKey:@"playlist[release_year]"];
	else
		[parameters removeObjectForKey:@"playlist[release_year]"];
	
	selected = [parameters objectForKey:@"playlist[license]"];
	if (selected == nil)
		selected = @"0";
	[parameters setObject:[licenseNames objectForKey:selected] forKey:@"playlist[license]"];
	
	// sharing
	[parameters setObject:([sharing selectedTag] == 0) ? @"public" : @"private" forKey:@"playlist[sharing]"];
	
	if ([sharing selectedTag] == 1)
		[parameters setObject:[invited objectValue] forKey:@"playlist[shared_to][emails][][address]"];
	
	// track IDs
	NSMutableArray *trackIDs = [NSMutableArray arrayWithCapacity:[[tracksController arrangedObjects] count]];
	for (Track *track in [tracksController arrangedObjects])
		if (track.uploadStatus >= kUploadStatusUploaded)
			[trackIDs addObject:[[track cloudID] description]];
		
	[parameters setObject:trackIDs forKey:@"playlist[tracks][][id]"];
	
	// reformat upc
	NSString *ean = [parameters objectForKey:@"playlist[ean]"];
	if ([ean length] == 12)
		[parameters setObject:[NSString stringWithFormat:@"0%@", ean] forKey:@"playlist[ean]"];
	
	// artwork
	if ([artwork image])
		[parameters setObject:[[artwork image] TIFFRepresentation] forKey:@"playlist[artwork_data]"];
	
	[[delegate apiController] postSetWithParameters:parameters
											   context:set
									   requestDelegate:self];
}


- (void)addFiles
{
	NSArray *fileTypes = [NSArray arrayWithObjects:@"aif", @"aiff", @"wav", @"flac", @"ogg", @"oga",
													@"mp3", @"aac", @"m4a", nil];
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
	[oPanel setAllowsMultipleSelection:YES];
	[oPanel beginSheetForDirectory:NSHomeDirectory()
							  file:nil
							 types:fileTypes
					modalForWindow:[[self view] window]
					 modalDelegate:self
					didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					   contextInfo:nil];
}


- (void)openPanelDidEnd:(NSOpenPanel *)panel
			 returnCode:(int)returnCode
			contextInfo:(void  *)contextInfo
{
	if (returnCode == NSOKButton)
	{
		[tracks addTracksWithFilenames:[panel filenames] andParentSet:set];
		[tracksController rearrangeObjects];
		
		[self checkTracksForUploadCompletion];
		[self uploadNextTrack];
		[delegate uploadControllerBeganUploading:self];
	}
}


#pragma mark CPSoundcloudAPIControllerDelegate

- (void)apiController:(CPSoundcloudAPIController *)controller didStartRequestWithContext:(id)context;
{
	if (context == set) // started sending the set
	{
		NSLog(@"Sending the set…");
		[sendingProgress startAnimation:self];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUploading) // started uploading a track
	{
		NSLog(@"Track named %@ started uploading", [context objectForKey:@"title"]);
		[[context statusViewController] showProgressBar];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUpdating) // started updating a track
	{
		NSLog(@"Track named %@ started updating", [context objectForKey:@"title"]);
	}
}


- (void)apiController:(CPSoundcloudAPIController *)controller didFinishRequestWithData:(NSData *)data context:(id)context;
{
	SBJSON *parser = [[SBJSON alloc] init];
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *trackData = [dataString JSONValue];
	
	if (context == set) // finished sending the set
	{
		NSLog(@"Set has been sent.");
		NSURL *url = [NSURL URLWithString:[trackData objectForKey:@"permalink_url"]];
		
		[sendingProgress stopAnimation:self];
		[overlay removeFromSuperview];
		[delegate uploadControllerFinishedUploading:self];
		[delegate uploadController:self endedWithRessourceURL:url];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUploading) // finished uploading a track
	{
		[context setCloudID:[trackData objectForKey:@"id"]];
		NSLog(@"Track named %@ finished uploading with id: %@", [context objectForKey:@"title"], [context cloudID]);
		
		[[context statusViewController] finishSuccessful:YES];
		[context setUploadStatus:kUploadStatusUploaded];
		
		[self uploadNextTrack];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUpdating) // finished updating a track
	{
		//NSLog([trackData description]);
		NSLog(@"Track named %@ has been updated.", [context objectForKey:@"title"]);
		
		[(Track *)context setUploadStatus:kUploadStatusFinished];
	}
	
	[dataString release];
	[parser release];
	
}


- (void)apiController:(CPSoundcloudAPIController *)controller didFinishRequestWithError:(NSError *)error context:(id)context;
{
	NSLog(@"Error: %@", [error localizedDescription]);
	
	if (context == set) // sending the set failed
	{
		NSLog(@"Set could not be sent.");

		NSAlert *theAlert;
		if (error.code == SCAPIErrorHttpResponseError)
			theAlert = [NSAlert alertWithError:[error.userInfo objectForKey:SCAPIHttpResponseErrorStatusKey]];
		else
			theAlert = [NSAlert alertWithError:error];
		[theAlert runModal];
		
		[sendingProgress stopAnimation:self];
		[overlay removeFromSuperview];
		[delegate uploadControllerFinishedUploading:self];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUploading) // uploading a track failed
	{
		NSLog(@"Track named %@ failed uploading", [context objectForKey:@"title"]);
		
		[[context statusViewController] finishSuccessful:NO];
		[(Track *)context setUploadStatus:kUploadStatusFailedUploading];
		
		[self uploadNextTrack];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUpdating) // updating a track failed
	{
		NSLog(@"Track named %@ failed updating", [context objectForKey:@"title"]);
		[(Track *)context setUploadStatus:kUploadStatusFailedUpdating];
	}
	
	if (error.code == SCAPIErrorHttpResponseError)
	{
		NSError *httpError = [error.userInfo objectForKey:SCAPIHttpResponseErrorStatusKey];
		NSLog(@"HTTP Error: %@", [httpError localizedDescription]);
	}
}


- (void)apiController:(CPSoundcloudAPIController *)controller uploadProgress:(double)progress context:(id)context;
{
	if (context == set)
	{
		[sendingProgress setDoubleValue:progress];
	}
	else if ([(Track *)context uploadStatus] == kUploadStatusUploading)
	{
		[[context statusViewController] setProgress:progress];
	}
}


#pragma mark Picture Taker Actions

- (IBAction)showPictureTaker:(id)sender
{
	IKPictureTaker *pt = [IKPictureTaker pictureTaker];
	
	if ([artwork image])
		[pt setInputImage:[artwork image]];
	[pt setMirroring:YES];
	[pt beginPictureTakerSheetForWindow:[[self view] window]
						   withDelegate:self
						 didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:)
							contextInfo:nil];
}


- (void) pictureTakerDidEnd:(IKPictureTaker *)thisPictureTaker
				 returnCode:(int)returnCode
				contextInfo:(void *)contextInfo
{
	if(returnCode == NSOKButton)
		[artwork setImage:[thisPictureTaker outputImage]];
}


#pragma mark NSTokenFieldDelegate
- (NSArray *)tokenField:(NSTokenField *)tokenField
completionsForSubstring:(NSString *)substring
		   indexOfToken:(NSInteger)tokenIndex
	indexOfSelectedItem:(NSInteger *)selectedIndex;
{
	if ([tokenField isEqual:invited]) {
		NSMutableArray *result = [NSMutableArray array];
		NSArray *people = [[ABAddressBook sharedAddressBook] people];
		for (ABPerson *person in people) {
			ABMultiValue *emailList = [[person valueForProperty:kABEmailProperty] mutableCopy];
			NSUInteger emailIndex, emailCount = [emailList count];
			for (emailIndex = 0; emailIndex < emailCount; emailIndex++) {
				NSString *email = [emailList valueAtIndex:emailIndex];
				if ([email hasPrefix:substring]) {
					[result addObject:email];
				}
			}
		}
		return result;
	}
	return nil;
}

#pragma mark Key-Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == [set setDict])
	{
		if ([keyPath isEqualToString:@"playlist_type"])
		{
			NSString *title = [[type selectedItem] title];
			NSCell *cell = [[NSCell alloc] initTextCell:title];
			NSSize size = [cell cellSize];
			[cell release];
			
			NSRect frame = [type frame];
			frame.size.width = size.width + 20.0;
			[type setFrame:frame];
		}
		else if ([keyPath isEqualToString:@"license"])
		{
			NSString *title = [[license selectedItem] title];
			NSImage *img = [[license selectedItem] image];
			NSCell *cell = [[NSCell alloc] initTextCell:title];
			CGFloat width = [cell cellSize].width + [img size].width;
			[cell release];
			
			NSRect frame = [license frame];
			frame.size.width = width + 20.0;
			[license setFrame:frame];
		}
	}
}

#pragma mark Notifications

- (void)myWindowDidResize:(NSNotification *)notification
{
	[tracksTable scrollRowToVisible:[tracksTable openRow]];
}

@end
