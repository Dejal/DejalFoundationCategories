//
//  NSDictionary+Dejal.h
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


@interface NSDictionary (Dejal)

+ (id)dejal_dictionaryWithArrayOfDictionaries:(NSArray *)array usingKey:(NSString *)key;

- (id)dejal_deepCopy NS_RETURNS_RETAINED;
- (id)dejal_deepMutableCopy NS_RETURNS_RETAINED;

- (id)dejal_nilOrObjectForKey:(id)aKey;
- (id)dejal_emptyStringOrObjectForKey:(id)aKey;

- (BOOL)dejal_hasKey:(id)key;

- (NSArray *)dejal_sortedKeys;

- (BOOL)dejal_boolForKey:(id)key;
- (NSInteger)dejal_integerForKey:(id)key;
- (CGFloat)dejal_floatForKey:(id)key;
- (NSTimeInterval)dejal_timeIntervalForKey:(id)key;

- (NSDate *)dejal_dateForKey:(id)key;
- (NSDate *)dejal_timeForKey:(id)key;

- (NSString *)dejal_descriptionForKey:(id)key;
- (NSInteger)dejal_stringLengthForKey:(id)key;
- (BOOL)dejal_containsSomethingForKey:(id)key;

- (id)dejal_objectForKey:(id)aKey orBool:(BOOL)aDefault;
- (id)dejal_objectForKey:(id)aKey orInteger:(BOOL)aDefault;

- (id)dejal_objectForKey:(id)aKey defaultValue:(id)aDefault;

- (id)dejal_keyForObject:(id)anObject;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSMutableDictionary (Dejal)

- (void)dejal_setBool:(BOOL)value forKey:(id)key;
- (void)dejal_setInteger:(NSInteger)value forKey:(id)key;
- (void)dejal_setFloat:(CGFloat)value forKey:(id)key;
- (void)dejal_setTimeInterval:(NSTimeInterval)value forKey:(id)key;

- (void)dejal_setDefaultValue:(id)aDefault forKey:(id)aKey;
- (void)dejal_setObject:(id)anObject forKey:(id)aKey defaultValue:(id)aDefault;
- (void)dejal_setObject:(id)anObject forKey:(id)aKey removeIfNil:(BOOL)removeIfNil;

- (void)dejal_replaceObject:(id)oldObject withObject:(id)newObject;

@end

