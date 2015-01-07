//
//  NSUserDefaults+Dejal.h
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


@interface NSUserDefaults (Dejal)

- (id)dejal_objectForKey:(id)aKey defaultValue:(id)aDefault;

- (void)dejal_setObject:(id)anObject forKey:(id)aKey defaultValue:(id)aDefault;
- (void)dejal_setObject:(id)anObject forKey:(id)aKey removeIfNil:(BOOL)removeIfNil;

- (id)dejal_sanitizeObject:(id)object;
- (void)dejal_setArbitraryObject:(id)object forKey:(NSString *)key;

- (NSInteger)dejal_incrementIntegerForKey:(NSString *)defaultName;

- (NSTimeInterval)dejal_timeIntervalForKey:(NSString *)defaultName;
- (NSTimeInterval)dejal_timeIntervalForKey:(NSString *)defaultName orDefaultTimeInterval:(NSTimeInterval)defaultTimeInterval;
- (void)dejal_setTimeInterval:(NSTimeInterval)timeInterval forKey:(NSString *)defaultName;

- (NSDictionary *)dejal_factorySettingsForKeys:(NSArray *)keysArray;

- (BOOL)dejal_changedFromFactorySettingsForKey:(NSString *)key;
- (BOOL)dejal_changedFromFactorySettingsForKeys:(NSArray *)keysArray;

- (void)dejal_restoreFactorySettingsForKey:(NSString *)key;
- (void)dejal_restoreFactorySettingsForKeys:(NSArray *)keysArray;

- (BOOL)dejal_copyObjectForKey:(NSString *)oldKey toKey:(NSString *)newKey replace:(BOOL)replace;
- (BOOL)dejal_copyObjectsForKeys:(NSArray *)keyPairsArray replace:(BOOL)replace;

- (void)dejal_copyPreferenceWithKey:(NSString *)preferenceKey fromBundleIdentifier:(NSString *)bundleIdentifier removeIfMissing:(BOOL)removeIfMissing;
- (void)dejal_copyPreferencesWithKeys:(NSArray *)preferenceKeys fromBundleIdentifier:(NSString *)bundleIdentifier removeIfMissing:(BOOL)removeIfMissing;

@end

