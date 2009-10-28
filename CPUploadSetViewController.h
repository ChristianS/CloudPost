//
//  CPUploadSetViewController.h
//  CloudPost
//
//  Created by Christian Stropp on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Quartz/Quartz.h>
#import "BackgroundColorView.h"
#import "UploadController.h"
#import "TracksTableView.h"
#import "CPSoundcloudAPIController.h"
#import "TracksArrayController.h"
#import "NSMutableArray-Tracks.h"
#import "Track.h"
#import "Set.h"


@interface CPUploadSetViewController : NSViewController <UploadController, CPSoundcloudAPIControllerDelegate> {
	IBOutlet BackgroundColorView *setView;
	IBOutlet BackgroundColorView *setDetailsView;
	IBOutlet BackgroundColorView *tracksView;
	IBOutlet TracksArrayController *tracksController;
	IBOutlet TracksTableView *tracksTable;
	IBOutlet BackgroundColorView *bottomControlsView;
	IBOutlet BackgroundColorView *inviteView;
	IBOutlet NSView *overlay;
	IBOutlet NSProgressIndicator *sendingProgress;
	
	id<UploadControllerDelegate> delegate;
	
	Set *set;
	NSMutableArray *tracks;
	
	NSMutableArray *years;
	NSDictionary *playlistTypeNames;
	NSDictionary *trackTypeNames;
	NSDictionary *licenseNames;
	
	// set input fields
	IBOutlet NSImageView *artwork;
	IBOutlet NSTextField *genre;
	IBOutlet NSButton *downloadable;
	IBOutlet NSButton *streaming;
	IBOutlet NSPopUpButton *type;
	IBOutlet NSPopUpButton *license;
	IBOutlet NSPopUpButton *releaseDateYear;
	IBOutlet NSPopUpButton *releaseDateMonth;
	IBOutlet NSPopUpButton *releaseDateDay;
	IBOutlet NSPopUpButton *sharing;
	IBOutlet NSTokenField *invited;
	
	IBOutlet NSButton *extraSetFieldsButton;
	IBOutlet NSTextField *publicLabel;
	IBOutlet NSTextField *privateLabel;
	
	Boolean setDetailsVisible;
	Boolean inviteViewVisible;
	Boolean isSetEditable;
}
@property (nonatomic, retain) Set *set;

- (void)hideView:(NSView *)view;
- (void)hideSetDetailsAndInvitView;
- (void)toggleSetDetailsAndInviteView;
- (IBAction)toggleSetDetails:(id)sender;
- (void)toggleInviteView;
- (IBAction)sharingChanged:(id)sender;

- (void)uploadNextTrack;
- (void)updateTracks;
- (void)checkTracksForUploadCompletion;
- (void)retryFailedTracks;

- (IBAction)showPictureTaker:(id)sender;
- (void) pictureTakerDidEnd:(IKPictureTaker *)thisPictureTaker returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end
