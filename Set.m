//
//  Set.m
//  CloudPost
//
//  Created by Christian Stropp on 03.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Set.h"


@implementation Set

@synthesize setDict;

- (id)init
{
	if (self = [super init])
	{
		setDict = [[NSMutableDictionary alloc] init];
		
		// set defaults for the Set
		[self setObject:@"New Set" forKey:@"title"];
	}
	
	return self;
}


- (void)dealloc
{
	[setDict release];
	[super dealloc];
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
	return [setDict objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
	[setDict setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
	[setDict removeObjectForKey:aKey];
}

#pragma mark Validation

- (BOOL)validateTitle:(id *)ioValue error:(NSError **)outError
{
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (!([*ioValue length] > 0))
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"Title must not be empty.", @"Set",
										@"validation: empty title error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Set"
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
										@"Genre must be shorter than 21 characters.", @"Set",
										@"validation: genre longer than 20 characters error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Set"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validateEan:(id *)ioValue error:(NSError **)outError
{
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (!([*ioValue length] == 13 || [*ioValue length] == 12))
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"EAN/UPC must be either 13 or 12 characters.", @"Set",
										@"validation: invalid ean error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Set"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}


- (BOOL)validatePurchase_url:(id *)ioValue error:(NSError **)outError
{
	NSPredicate *urlPred = [NSPredicate predicateWithFormat:@"SELF MATCHES '^http://.*'"];
	
	if (*ioValue == nil)
		*ioValue = @"";
	
	if (![*ioValue isEqualToString:@""] && ![urlPred evaluateWithObject:*ioValue])
	{
		NSString *errorString = NSLocalizedStringFromTable(
										@"URL must begin with http://", @"Set",
										@"validation: invalid url error");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorString
																 forKey:NSLocalizedDescriptionKey];
        NSError *error = [[[NSError alloc] initWithDomain:@"Set"
													 code:0
												 userInfo:userInfoDict] autorelease];
        *outError = error;
		
		return NO;
	}
	
	return YES;
}

@end
