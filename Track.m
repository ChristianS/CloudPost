//
//  Track.m
//  CloudPost
//
//  Created by Christian Stropp on 01.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Track.h"


@implementation Track

@synthesize set;
@synthesize uploadStatus;
@synthesize statusViewController;
@synthesize cloudID;

- (id)initWithFileURL:(NSURL *)fileURL andSet:(Set *)parentSet
{
	if (self = [super init])
	{
		self.set = parentSet;
		
		trackDict = [[NSMutableDictionary alloc] init];
		[trackDict setObject:fileURL forKey:@"asset_data"];
		NSString *niceFilename = [[fileURL lastPathComponent] stringByDeletingPathExtension];
		niceFilename = [niceFilename stringByReplacingOccurrencesOfString:@"_" withString:@" "];
		[trackDict setObject:niceFilename forKey:@"title"];
		
		uploadStatus = kUploadStatusLocal;
		statusViewController = [[CPStatusViewController alloc] initWithNibName:@"StatusView" bundle:nil];
	}
	return self;
}


- (void)dealloc
{
	[trackDict release];
	[set release];
	[super dealloc];
}


- (NSDictionary *)mergedDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:trackDict];
	
	if (set != nil)
	{
		NSArray *keys = [[NSArray alloc] initWithObjects:@"genre", @"label_name", @"release",
						 @"tag_list", @"license",
						 @"release_year", @"release_month", @"release_day", nil];
		id trackValue;
		id setValue;
		
		for (NSString *key in keys)
			if (!(trackValue == [dict objectForKey:key]))
				if (setValue == [set objectForKey:key])
					[dict setObject:setValue forKey:key];
	}
	
	return dict;
}


#pragma mark Key-value Coding

- (id)valueForKey:(NSString *)key
{
	return [self objectForKey:key];
}


- (void)setValue:(id)value forKey:(NSString *)key
{
	[self setObject:value forKey:key];
}


- (id)objectForKey:(id)aKey
{
	id trackValue = [trackDict objectForKey:aKey];
	
	if (trackValue == nil && set != nil)
		if ([aKey isEqualToString:@"genre"] || [aKey isEqualToString:@"label_name"]
			|| [aKey isEqualToString:@"release"] || [aKey isEqualToString:@"tag_list"])
		{
			id object = [set objectForKey:aKey];
			if (![object isKindOfClass:[NSString class]])
				return [set objectForKey:aKey];
			
			NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
								  [NSColor grayColor], NSForegroundColorAttributeName, nil];
			NSAttributedString *string = [[NSAttributedString alloc] initWithString:(NSString *)object
																		 attributes:dict];
			[dict release];
			
			return [string autorelease];
		}
		else if ([aKey isEqualToString:@"license"] || [aKey isEqualToString:@"release_year"]
				|| [aKey isEqualToString:@"release_month"] || [aKey isEqualToString:@"release_day"])
		{
			return [set objectForKey:aKey];
		}
	
	return trackValue;
}


- (void)setObject:(id)anObject forKey:(id)aKey
{
	[trackDict setObject:anObject forKey:aKey];
}


- (void)removeObjectForKey:(id)aKey
{
	[trackDict removeObjectForKey:aKey];
}

#pragma mark Validation

- (BOOL)validateTitle:(id *)ioValue error:(NSError **)outError
{
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (!([*ioValue length] > 0))
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"Title must not be empty.", @"Track",
										@"validation: empty title error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Track"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validateGenre:(id *)ioValue error:(NSError **)outError
{
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (!([*ioValue length] <= 20))
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"Genre must be shorter than 21 characters.", @"Track",
										@"validation: genre longer than 20 characters error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Track"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validateBpm:(id *)ioValue error:(NSError **)outError
{
	NSPredicate *bpmPred = [NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\d+'"];
	
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (![*ioValue isEqualToString:@""] && ![bpmPred evaluateWithObject:*ioValue])
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"BPM must be an integer.", @"Track",
										@"validation: bpm not an integer error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Track"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validateIsrc:(id *)ioValue error:(NSError **)outError
{
	NSPredicate *isrcPred = 
		[NSPredicate predicateWithFormat:@"SELF MATCHES '^([^-]{2}-[^-]{3}-[^-]{2}-[^-]{5})$'"];
	
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (![*ioValue isEqualToString:@""] && ![isrcPred evaluateWithObject:*ioValue])
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"ISRC must be in the format CC-XXX-YY-NNNNN.", @"Track",
										@"validation: invalid isrc format error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Track"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validatePurchase_url:(id *)ioValue error:(NSError **)outError
{
	return [self validateVideo_url:ioValue error:outError];
}


- (BOOL)validateVideo_url:(id *)ioValue error:(NSError **)outError
{
	NSPredicate *urlPred = [NSPredicate predicateWithFormat:@"SELF MATCHES '^http://.*'"];
	
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (![*ioValue isEqualToString:@""] && ![urlPred evaluateWithObject:*ioValue])
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"URL must begin with http://", @"Track",
										@"validation: invalid url error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Track"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}

@end
