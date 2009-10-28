//
//  CPSoundcloudAPIController.m
//  CloudPost
//
//  Created by Ullrich Schäfer on 12.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CPSoundcloudAPIController.h"
#import "CloudPostAppDelegate.h"
#import "Track.h"


#define	kContextKey		@"context"
#define kDelegateKey	@"delegate"

@implementation CPSoundcloudAPIController

#pragma mark Lifecycle
- (id)initWithAuthenticationDelegate:(id<SCSoundCloudAPIAuthenticationDelegate>)authDelegate;
{
	if (self = [super init]) {
		api = [[SCSoundCloudAPI alloc] initWithAuthenticationDelegate:authDelegate];
		api.delegate = self;
		api.responseFormat = SCResponseFormatJSON;
	}
	return self;
}

- (void)dealloc;
{
	[api release];
	[super dealloc];
}

#pragma mark Accessors
@synthesize api;

#pragma mark Publics
- (void)postTrackWithParameters:(NSDictionary *)parameters
						context:(id)context
				requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;
{
	[api performMethod:@"POST"
			onResource:@"tracks"
		withParameters:parameters
			   context:[NSDictionary dictionaryWithObjectsAndKeys:
						delegate, kDelegateKey,
						context, kContextKey,
						nil]];
	[delegate apiController:self didStartRequestWithContext:context];
}


- (void)putTrackWithParameters:(NSDictionary *)parameters
					   context:(id)context
			   requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;
{
	[api performMethod:@"PUT"
			onResource:[NSString stringWithFormat:@"tracks/%@", [(Track *)context cloudID]]
		withParameters:parameters
			   context:[NSDictionary dictionaryWithObjectsAndKeys:
						delegate, kDelegateKey,
						context, kContextKey,
						nil]];
	[delegate apiController:self didStartRequestWithContext:context];
}


- (void)postSetWithParameters:(NSDictionary *)parameters
						context:(id)context
				requestDelegate:(id<CPSoundcloudAPIControllerDelegate>)delegate;
{
	[api performMethod:@"POST"
			onResource:@"playlists"
		withParameters:parameters
			   context:[NSDictionary dictionaryWithObjectsAndKeys:
						delegate, kDelegateKey,
						context, kContextKey,
						nil]];
	[delegate apiController:self didStartRequestWithContext:context];
}

#pragma mark SCSoundCloudAPIDelegate
- (void)soundCloudAPI:(SCSoundCloudAPI *)api didFinishWithData:(NSData *)data context:(id)context;
{
	[[context objectForKey:kDelegateKey] apiController:self didFinishRequestWithData:data context:[context objectForKey:kContextKey]];
}
- (void)soundCloudAPI:(SCSoundCloudAPI *)api didFailWithError:(NSError *)error context:(id)context;
{
	[[context objectForKey:kDelegateKey] apiController:self didFinishRequestWithError:error context:[context objectForKey:kContextKey]];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)api didReceiveData:(NSData *)data context:(id)context;
{}

- (void)soundCloudAPI:(SCSoundCloudAPI *)api didReceiveBytes:(unsigned long long)loadedBytes total:(unsigned long long)totalBytes context:(id)context;
{}

- (void)soundCloudAPI:(SCSoundCloudAPI *)api didSendBytes:(unsigned long long)sendBytes total:(unsigned long long)totalBytes context:(id)context;
{
	if ([[context objectForKey:kDelegateKey] respondsToSelector:@selector(apiController:uploadProgress:context:)])
		[[context objectForKey:kDelegateKey] apiController:self uploadProgress:((double)sendBytes / (double)totalBytes) context:[context objectForKey:kContextKey]];
}

@end
