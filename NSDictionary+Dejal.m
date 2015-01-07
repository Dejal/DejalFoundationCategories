//
//  NSDictionary+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Sat Aug 10 2002.
//  Copyright (c) 2002-2015 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDictionary+Dejal.h"
#import "NSString+Dejal.h"
#import "NSDate+Dejal.h"


@implementation NSDictionary (Dejal)

/**
 Given an array that contains dictionaries, and a key that is used in those dictionaries, returns a new dictionary that has the values of those keys as the keys, and the dictionaries as the values.  Returns nil if the array or key parameters are nil.  Effectively the reverse of the -allValues method.
 
 @author DJS 2004-06.
*/

+ (id)dejal_dictionaryWithArrayOfDictionaries:(NSArray *)array usingKey:(NSString *)key;
{
    if (!array || !key)
        return nil;
    
    NSMutableDictionary *masterDict = [NSMutableDictionary dictionaryWithCapacity:[array count]];
    NSDictionary *subDict;
    
    for (subDict in array)
    {
        NSString *identifier = subDict[key];
        
        if (identifier)
            masterDict[identifier] = subDict;
    }
    
    return masterDict;
}

/**
 Similar to -copy, but each of the objects in the dictionary are copied too (using the same keys).  Note that like -copy, the dictionary is retained.
 
 @author DJS 2004-06.
 @version DJS 2006-01: changed to fix memory leak through excessive retaining.
 @version DJS 2009-01: changed to use fast enumeration.
*/

- (id)dejal_deepCopy;
{
    id dict = [NSMutableDictionary new];
    id copy;
    
    for (id key in self)
    {
        id object = self[key];
        
        if ([object respondsToSelector:@selector(dejal_deepCopy)])
            copy = [object dejal_deepCopy];
        else
            copy = [object copy];
        
    	dict[key] = copy;
    }
    
    return dict;
}

/**
 Similar to -dejal_deepCopy, above, but makes all of the contents of the dictionary mutable.
 
 @author DJS 2009-01.
*/

- (id)dejal_deepMutableCopy;
{
    id dict = [NSMutableDictionary new];
    id mutableCopy;
    
    for (id key in self)
    {
        id object = self[key];
        
        if ([object respondsToSelector:@selector(dejal_deepMutableCopy)])
            mutableCopy = [object dejal_deepMutableCopy];
        else if ([object conformsToProtocol:@protocol(NSMutableCopying)])
            mutableCopy = [object mutableCopy];
        else
            mutableCopy = [object copy];
        
    	dict[key] = mutableCopy;
    }
    
    return dict;
}

/**
 Returns an entry's value given its key, or nil if no value is associated with aKey, or it is NSNull.
 
 @author DJS 2012-05.
*/

- (id)dejal_nilOrObjectForKey:(id)aKey;
{
    id value = self[aKey];
    
    if ([value isKindOfClass:[NSNull class]])
        value = nil;
    
    return value;
}

/**
 Returns an entry's value given its key, or an empty string (@"") if no value is associated with aKey, or it is NSNull.
 
 @author DJS 2004-01.
 @version DJS 2012-05: changed to return an empty string instead of NSNull.
*/

- (id)dejal_emptyStringOrObjectForKey:(id)aKey;
{
    id value = self[aKey];
    
    if (!value || [value isKindOfClass:[NSNull class]])
        value = @"";
    
    return value;
}

/**
 Returns YES if the key exists in the dictionary, or NO if it doesn't.  Dubious benefit, since -objectForKey:'s result can be treated as a boolean anyway, but sometimes you want an actual BOOL value.
 
 @author DJS 2005-02.
*/

- (BOOL)dejal_hasKey:(id)key;
{
    return (self[key] != nil);
}

/**
 Like -allKeys, but sorted in ascending alphabetical order by the dictionary's keys (not case sensitive).
 
 @author DJS 2006-09.
*/

- (NSArray *)dejal_sortedKeys;
{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

// NOTE: may want to add -arrayForKey:, -mutableArrayForKey:, and other variations too sometime.

/**
 Returns YES if the value for this key is a string containing "yes" (case insensitive), or a number with a non-zero value.  Otherwise returns NO.
 
 @author DJS 2005-02.
*/

- (BOOL)dejal_boolForKey:(id)key;
{
    NSString *value = [self dejal_descriptionForKey:key];
    
    if (value)
        return ([value integerValue] || [[value lowercaseString] isEqualToString:@"yes"]);
    else
        return NO;
}

/**
 Invokes descriptionForKey: with the key.  Returns 0 if no string is returned.  Otherwise, the resulting string is sent an integerValue message, which provides this method's return value.
 
 @author DJS 2005-02.
*/

- (NSInteger)dejal_integerForKey:(id)key;
{
    NSString *value = [self dejal_descriptionForKey:key];
    
    if (value)
        return [value integerValue];
    else
        return 0;
}

/**
 Invokes descriptionForKey: with the key.  Returns 0.0 if no string is returned.  Otherwise, the resulting string is sent a floatValue message, which provides this method's return value.
 
 @author DJS 2005-02.
*/

- (CGFloat)dejal_floatForKey:(id)key;
{
    NSString *value = [self dejal_descriptionForKey:key];
    
    if (value)
        return [value floatValue];
    else
        return 0.0;
}

/**
 Invokes descriptionForKey: with the key.  Returns 0.0 if no string is returned.  Otherwise, the resulting string is sent a doubleValue message, which provides this method's return value.
 
 @author DJS 2005-02.
*/

- (NSTimeInterval)dejal_timeIntervalForKey:(id)key
{
    NSString *value = [self dejal_descriptionForKey:key];
    
    if (value)
        return [value doubleValue];
    else
        return 0.0;
}

/**
 Returns a date from a JSON string, or nil if NSNull or not a valid date.
 
 @author DJS 2012-07.
*/

- (NSDate *)dejal_dateForKey:(id)key;
{
    return [NSDate dejal_dateWithJSONString:[self dejal_nilOrObjectForKey:key] allowPlaceholder:NO];
}

/**
 Returns a time from a JSON string, or nil if NSNull or not a valid time.
 
 @author DJS 2012-07.
*/

- (NSDate *)dejal_timeForKey:(id)key;
{
    return [NSDate dejal_dateWithJSONString:[self dejal_nilOrObjectForKey:key] allowPlaceholder:YES];
}

/**
 Like -objectForKey:, but always returns a string, or nil if there is no object with that key.  Uses -description to convert any non-string types to a string equivalent.
 
 @author DJS 2005-02.
 @version DJS 2012-02: changed to rename from -stringForKey: due to a conflict with 10.7.3.
*/

- (NSString *)dejal_descriptionForKey:(id)key;
{
    return [self[key] description];
}

/**
 Returns the length of the object interpreted as a string.  See also -containsSomethingForKey:, below.
 
 @author DJS 2005-02.
*/

- (NSInteger)dejal_stringLengthForKey:(id)key;
{
    return [[self dejal_descriptionForKey:key] length];
}

/**
 Returns YES if the object interpreted as a string is non-empty, i.e. not nil and not @"".  See also -stringLengthForKey:, above.
 
 @author DJS 2005-02.
*/

- (BOOL)dejal_containsSomethingForKey:(id)key;
{
    return ([[self dejal_descriptionForKey:key] length] > 0);
}

/**
 Returns an entry's value given its key, or a NSNumber with the aDefault boolean if no value is associated with aKey.
 
 @author DJS 2004-06.
*/

- (id)dejal_objectForKey:(id)aKey orBool:(BOOL)aDefault;
{
    id value = self[aKey];
    
    if (!value)
        value = @(aDefault);
    
    return value;
}

/**
 Returns an entry's value given its key, or a NSNumber with the aDefault integer if no value is associated with aKey.
 
 @author DJS 2004-06.
*/

- (id)dejal_objectForKey:(id)aKey orInteger:(BOOL)aDefault;
{
    id value = self[aKey];
    
    if (!value)
        value = @(aDefault);
    
    return value;
}

/**
 Returns an entry's value given its key, or the default value if no value is associated with aKey.
 
 @author DJS 2004-01.
*/

- (id)dejal_objectForKey:(id)aKey defaultValue:(id)aDefault;
{
    id value = self[aKey];
    
    if (!value)
        value = aDefault;
    
    return value;
}

/**
 Given an object, returns the key for its first occurrence in the receiver, or nil if it is nil or not present.  [Once 10.6 is the minimum, might want to use -keysOfEntriesPassingTest: instead for more flexiblity.]
 
 @author DJS 2010-07.
*/

- (id)dejal_keyForObject:(id)anObject;
{
    if (!anObject)
        return nil;
    
    for (NSString *key in self)
        if ([self[key] isEqual:anObject])
            return key;
    
    return nil;
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSMutableDictionary (Dejal)

/**
 Sets a NSNumber value in the mutable dictionary with the specified key.
 
 @author DJS 2005-02.
*/

- (void)dejal_setBool:(BOOL)value forKey:(id)key;
{
    self[key] = @(value);
}

/**
 Sets a NSNumber value in the mutable dictionary with the specified key.
 
 @author DJS 2005-02.
 */

- (void)dejal_setInteger:(NSInteger)value forKey:(id)key;
{
    self[key] = @(value);
}

/**
 Sets a NSNumber value in the mutable dictionary with the specified key.
 
 @author DJS 2005-02.
 */

- (void)dejal_setFloat:(CGFloat)value forKey:(id)key;
{
    self[key] = @(value);
}

/**
 Sets a NSNumber value in the mutable dictionary with the specified key.
 
 @author DJS 2011-07.
*/

- (void)dejal_setTimeInterval:(NSTimeInterval)value forKey:(id)key
{
    self[key] = @(value);
}

/**
 If there is no object already set for the key, sets the default value.  If there was already a value, does nothing.
 
 @author DJS 2010-06.
*/

- (void)dejal_setDefaultValue:(id)aDefault forKey:(id)aKey;
{
    if (!self[aKey])
        self[aKey] = aDefault;
}

/**
 Adds an entry to the receiver, consisting of aKey and its corresponding value object anObject.  If anObject is nil, sets the default value instead; does nothing if both objects are nil.
 
 @author DJS 2004-01.
*/

- (void)dejal_setObject:(id)anObject forKey:(id)aKey defaultValue:(id)aDefault;
{
    if (anObject)
        self[aKey] = anObject;
    else if (aDefault)
        self[aKey] = aDefault;
}

/**
 Adds an entry to the receiver, consisting of aKey and its corresponding value object anObject.  If anObject is nil and removeIfNil is YES, the key is instead removed from the receiver, if already present, otherwise nothing happens; useful to avoid an exception when an object may be nil.  Note: invoking this with YES for removeIfNil is equivalent to using -setValue:forKey:, so better to use that.
 
 @author DJS 2004-01.
*/

- (void)dejal_setObject:(id)anObject forKey:(id)aKey removeIfNil:(BOOL)removeIfNil;
{
    if (anObject)
        self[aKey] = anObject;
    else if (removeIfNil)
        [self removeObjectForKey:aKey];
}

/**
 If oldObject is present in the receiver, it is replaced with newObject, otherwise this has no effect.  Only replaces the first occurrence [could add an argument to replace all if desired in the future].
 
 @author DJS 2010-07.
*/

- (void)dejal_replaceObject:(id)oldObject withObject:(id)newObject;
{
    NSString *key = [self dejal_keyForObject:oldObject];
    
    if (key && newObject)
        self[key] = newObject;
}

@end

