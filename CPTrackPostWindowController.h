//
//  CPTrackPostWindowController.h
//  CloudPost
//
//  Created by Ullrich Schäfer on 11.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "UploadController.h"
#import "NSMutableArray-Tracks.h"
#import "Set.h"
#import <SoundCloudAPI/SCAPI.h>
#import "CPSoundcloudAPIController.h"


@interface CPTrackPostWindowController : NSWindowController <UploadControllerDelegate, SCSoundCloudAPIAuthenticationDelegate> {
	IBOutlet NSView *styledWindowContentView;
	IBOutlet NSButton *sendButton;
	IBOutlet NSButton *addButton;
	IBOutlet NSProgressIndicator *activityIndicator;
	
	IBOutlet NSView *dropView;
	IBOutlet NSView *authView;
	IBOutlet NSView *completeAuthView;
	
	IBOutlet NSView *successView;
	IBOutlet NSTextField *urlLabel;
	
	NSViewController<UploadController> *uploadController;
	
	Set *set;
	NSMutableArray *tracks;
	
	SCSoundCloudAPIConfiguration *scApiConfig;
	CPSoundcloudAPIController *apiController;
	BOOL hasAPIConnection;
	NSURL *oAuthURL;
}
@property (nonatomic, retain) NSMutableArray *tracks;
@property (readonly) BOOL hasAPIConnection;
@property (nonatomic, retain) NSURL *oAuthURL;

- (void)openDroppedFiles:(NSArray *)filePaths;
- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;

- (IBAction)authorize:(id)sender;
- (IBAction)completeAuthorization:(id)sender;
- (IBAction)showDropView:(id)sender;
- (IBAction)cancel:(id)sender;

@end
