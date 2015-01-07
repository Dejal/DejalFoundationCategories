//
//  NSUserDefaults+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Thu Jul 03 2003.
//  Copyright (c) 2003-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSUserDefaults+Dejal.h"
#import "NSString+Dejal.h"
#import "NSDictionary+Dejal.h"


@implementation NSUserDefaults (Dejal)

/**
 Returns an entry's value given its key, or the default value if no value is associated with aKey.
 
 @author DJS 2010-10.
*/

- (id)dejal_objectForKey:(id)aKey defaultValue:(id)aDefault;
{
    id value = [self objectForKey:aKey];
    
    if (!value)
        value = aDefault;
    
    return value;
}

/**
 Adds an entry to the receiver, consisting of aKey and its corresponding value object anObject.  If anObject is nil, sets the default value instead; does nothing if both objects are nil.
 
 @author DJS 2007-01.
*/

- (void)dejal_setObject:(id)anObject forKey:(id)aKey defaultValue:(id)aDefault;
{
    if (anObject)
        [self setObject:anObject forKey:aKey];
    else if (aDefault)
        [self setObject:aDefault forKey:aKey];
}

/**
 Adds an entry to the receiver, consisting of aKey and its corresponding value object anObject.  If anObject is nil and removeIfNil is YES, the key is instead removed from the receiver, if already present, otherwise nothing happens; useful to avoid an exception when an object may be nil.
 
 @author DJS 2007-01.
*/

- (void)dejal_setObject:(id)anObject forKey:(id)aKey removeIfNil:(BOOL)removeIfNil;
{
    if (anObject)
        [self setObject:anObject forKey:aKey];
    else if (removeIfNil)
        [self removeObjectForKey:aKey];
}

/**
 Given an arbitrary object, makes it safe to store in user defaults.  Array and dictionary hierarchies are preserved, and their values are recursively sanitized.  Non property-list objects are just stored as their description for now; this could be improved to encode as data (if the object supports coding).
 
 @param object An arbitrary object or collection.
 @returns An object or collection with only property list objects.
 
 @author DJS 2015-01.
 */

- (id)dejal_sanitizeObject:(id)object;
{
    if ([object isKindOfClass:[NSArray class]])
    {
        NSMutableArray *result = [NSMutableArray array];
        
        for (id item in object)
        {
            [result addObject:[self dejal_sanitizeObject:item]];
        }
        
        object = result;
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             [result setObject:[self dejal_sanitizeObject:obj] forKey:key];
         }];
        
        object = result;
    }
    else if (![object isKindOfClass:[NSString class]] && ![object isKindOfClass:[NSNumber class]] && ![object isKindOfClass:[NSDate class]] && ![object isKindOfClass:[NSData class]])
    {
        object = [object description];
    }
    
    return object;
}

/**
 Given an arbitrary object, safely sets it in the receiver.  Array and dictionary hierarchies are preserved, and their values are recursively sanitized.  Non property-list objects are just stored as their description for now; this could be improved to encode as data (if the object supports coding).
 
 @param object An arbitrary object or collection.
 @param key The key to store it as.
 
 @author DJS 2015-01.
 */

- (void)dejal_setArbitraryObject:(id)object forKey:(NSString *)key;
{
    object = [self dejal_sanitizeObject:object];
    
    if (object)
    {
        [self setObject:object forKey:key];
    }
}

/**
 Convenience method to increment an integer user default value.
 
 @author DJS 2008-04.
*/

- (NSInteger)dejal_incrementIntegerForKey:(NSString *)defaultName;
{
    NSInteger value = [self integerForKey:defaultName] + 1;
    
    [self setInteger:value forKey:defaultName];
    
    return value;
}

/**
 Returns a time interval from the defaults with the specified key.  If there is no preference with that key, zero is returned instead.
 
 @author DJS 2011-07.
*/

- (NSTimeInterval)dejal_timeIntervalForKey:(NSString *)defaultName;
{
    return [self dejal_timeIntervalForKey:defaultName orDefaultTimeInterval:0.0];
}

/**
 Returns a time interval from the defaults with the specified key.  If there is no preference with that key, the specified time interval is returned instead.
 
 @author DJS 2011-07.
*/

- (NSTimeInterval)dejal_timeIntervalForKey:(NSString *)defaultName orDefaultTimeInterval:(NSTimeInterval)defaultTimeInterval;
{
    NSNumber *value = [self objectForKey:defaultName];
    
    if (value)
        return [value doubleValue];
    else
        return defaultTimeInterval;
}

/**
 Stores the specified time interval in the defaults with the specified key.
 
 @author DJS 2011-07.
*/

- (void)dejal_setTimeInterval:(NSTimeInterval)timeInterval forKey:(NSString *)defaultName;
{
    [self setObject:@(timeInterval) forKey:defaultName];
}

/**
 Given an array of user default keys, returns the factory settings, i.e. as set by -registerDefaults:.
 
 @author DJS 2007-11.
*/

- (NSDictionary *)dejal_factorySettingsForKeys:(NSArray *)keysArray;
{
    return [[self volatileDomainForName:NSRegistrationDomain] dictionaryWithValuesForKeys:keysArray];
}

/**
 Given a user default key, returns YES if that default has been changed from its factory setting, i.e. as set by -registerDefaults:.
 
 @author DJS 2003-07.
*/

- (BOOL)dejal_changedFromFactorySettingsForKey:(NSString *)key
{
    NSDictionary *factorySettings = [self volatileDomainForName:NSRegistrationDomain];

    return ![factorySettings[key] isEqual:[self objectForKey:key]];
}

/**
 Given an array of user default keys, returns YES if that default has been changed from its factory setting, i.e. as set by -registerDefaults:.
 
 @author DJS 2003-07.
*/

- (BOOL)dejal_changedFromFactorySettingsForKeys:(NSArray *)keysArray
{
    NSDictionary *factorySettings = [self volatileDomainForName:NSRegistrationDomain];
    NSEnumerator *enumerator = [keysArray objectEnumerator];
    NSString *key;
    BOOL changed = NO;

    while (!changed && (key = [enumerator nextObject]))
        changed = ![factorySettings[key] isEqual:[self objectForKey:key]];

    return changed;
}

/**
 Given a user default key, restores its value to the factory settings, i.e. as set by -registerDefaults:.
 
 @author DJS 2004-01.
*/

- (void)dejal_restoreFactorySettingsForKey:(NSString *)key
{
    [self removeObjectForKey:key];
}

/**
 Given an array of user default keys, restores all of their values to the factory settings, i.e. as set by -registerDefaults:.
 
 @author DJS 2003-07.
 */

- (void)dejal_restoreFactorySettingsForKeys:(NSArray *)keysArray
{
    NSString *key;
    
    for (key in keysArray)
        [self dejal_restoreFactorySettingsForKey:key];
}

/**
 Given a user default key of an old preference, and the new key for that preference, copies the corresponding object to the new key.  If there was no object with the old key, does nothing.  If replace is NO, the object is not copied if a preference already exists for the new key.  Returns YES if an object was copied.
 
 @author DJS 2006-02.
*/

- (BOOL)dejal_copyObjectForKey:(NSString *)oldKey toKey:(NSString *)newKey replace:(BOOL)replace;
{
    id oldObject = [self objectForKey:oldKey];
    BOOL hasNewValue = [self dejal_changedFromFactorySettingsForKey:newKey];
    BOOL okayToCopy = (oldObject && (!hasNewValue || replace));
    
    if (okayToCopy)
        [self setObject:[oldObject copy] forKey:newKey];
    
    return okayToCopy;
}

/**
 Given an array of pairs of old and new user default keys, copies the corresponding objects from the old to new keys.  Old keys with no objects are skipped.  If replace is NO, new keys with existing objects are also skipped.  Returns YES if any object were copied.
 
 @author DJS 2006-02.
*/

- (BOOL)dejal_copyObjectsForKeys:(NSArray *)keyPairsArray replace:(BOOL)replace;
{
    NSEnumerator *enumerator = [keyPairsArray objectEnumerator];
    NSString *oldKey;
    NSString *newKey;
    BOOL any = NO;
    
    while ((oldKey = [enumerator nextObject]) && (newKey = [enumerator nextObject]))
    {
    	any = any && [self dejal_copyObjectForKey:oldKey toKey:newKey replace:replace];
    }
    
    return any;
}

/**
 Copies one preference from the preference file with the specified bundle identifier to the receiver's preferences.  If a preference isn't set in the other file, it can either be skipped or removed from the receiver's preferences.
 
 @author DJS 2007-03.
*/

- (void)dejal_copyPreferenceWithKey:(NSString *)preferenceKey fromBundleIdentifier:(NSString *)bundleIdentifier removeIfMissing:(BOOL)removeIfMissing;
{
    [self dejal_copyPreferencesWithKeys:@[preferenceKey] fromBundleIdentifier:bundleIdentifier removeIfMissing:removeIfMissing];
}

/**
 Copies any number of preferences from the preference file with the specified bundle identifier to the receiver's preferences.  If a preference isn't set in the other file, it can either be skipped or removed from the receiver's preferences.
 
 @author DJS 2007-03.
*/

- (void)dejal_copyPreferencesWithKeys:(NSArray *)preferenceKeys fromBundleIdentifier:(NSString *)bundleIdentifier removeIfMissing:(BOOL)removeIfMissing;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *domain = [defaults persistentDomainForName:bundleIdentifier];
    NSString *key;
    
    for (key in preferenceKeys)
    {
    	id object = domain[key];
        
        if (object)
            [defaults setObject:object forKey:key];
        else if (removeIfMissing)
            [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
}

@end

