//
//  Set.h
//  CloudPost
//
//  Created by Christian Stropp on 03.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Set : NSObject {
	NSMutableDictionary *setDict;
}
@property (readonly) NSMutableDictionary *setDict;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;

- (BOOL)validateTitle:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateGenre:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateEan:(id *)ioValue error:(NSError **)outError;
- (BOOL)validatePurchase_url:(id *)ioValue error:(NSError **)outError;

@end
