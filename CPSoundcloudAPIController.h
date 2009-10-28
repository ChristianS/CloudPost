//
//  CPSoundcloudAPIController.h
//  CloudPost
//
//  Created by Ullrich Schäfer on 12.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SoundCloudAPI/SCAPI.h>

@protocol CPSoundcloudAPIControllerDelegate;


@interface CPSoundcloudAPIController : NSObject <SCSoundCloudAPIDelegate> {
	SCSoundCloudAPI	*api;
}
@property (readonly) SCSoundCloudAPI	*api;

- (void)postTrackWithParameters:(NSDictionary *)parameters context:(id)context requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;
- (void)putTrackWithParameters:(NSDictionary *)parameters context:(id)context requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;
- (void)postSetWithParameters:(NSDictionary *)parameters context:(id)context requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;

@end



@protocol CPSoundcloudAPIControllerDelegate <NSObject>
- (void)apiController:(CPSoundcloudAPIController *)controller didStartRequestWithContext:(id)context;
- (void)apiController:(CPSoundcloudAPIController *)controller didFinishRequestWithData:(NSData *)data context:(id)context;
- (void)apiController:(CPSoundcloudAPIController *)controller didFinishRequestWithError:(NSError *)error context:(id)context;
@optional
- (void)apiController:(CPSoundcloudAPIController *)controller uploadProgress:(double)progress context:(id)context;
@end
