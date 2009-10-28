//
//  UploadController.h
//  CloudPost
//
//  Created by Christian Stropp on 30.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Set.h"

@class CPSoundcloudAPIController;


@protocol UploadControllerDelegate

@required

@property (readonly) CPSoundcloudAPIController* apiController;

@optional

- (void)uploadControllerBeganUploading:(id)uploadController;
- (void)uploadControllerFinishedUploading:(id)uploadController;
- (void)uploadController:(id)uploadController endedWithRessourceURL:(NSURL *)url;

@end


@protocol UploadController

@required

@property (nonatomic, assign) id<UploadControllerDelegate> delegate;

- (id)initWithTracks:(NSMutableArray *)newTracks andSet:(Set *)newSet;

- (void)send;

@optional

- (void)addFiles;


@end
