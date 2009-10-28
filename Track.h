//
//  Track.h
//  CloudPost
//
//  Created by Christian Stropp on 01.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Set.h"
#import "CPStatusViewController.h"

typedef enum {
	kUploadStatusLocal = 0,
	kUploadStatusFailedUploading,
	kUploadStatusUploading,
	kUploadStatusUploaded,
	kUploadStatusFailedUpdating,
	kUploadStatusUpdating,
	kUploadStatusFinished
} UploadStatus;


@interface Track : NSObject {
	NSMutableDictionary *trackDict;
	Set *set;
	UploadStatus uploadStatus;
	CPStatusViewController *statusViewController;
	NSString *cloudID;
}
@property (nonatomic, retain) Set *set;
@property (nonatomic, assign) UploadStatus uploadStatus;
@property (nonatomic, retain) CPStatusViewController *statusViewController;
@property (nonatomic, retain) NSString *cloudID;

- (id)initWithFileURL:(NSURL *)fileURL andSet:(Set *)parentSet;

- (NSDictionary *)mergedDictionary;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;

- (BOOL)validateTitle:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateGenre:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateBpm:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateIsrc:(id *)ioValue error:(NSError **)outError;
- (BOOL)validatePurchase_url:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateVideo_url:(id *)ioValue error:(NSError **)outError;

@end
