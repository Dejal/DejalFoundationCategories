//
//  NSObject+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Tue Sep 24 2002.
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


@interface NSObject (Dejal)

- (id)dejal_valueForKeyPath:(NSString *)keyPath defaultValue:(id)defaultValue;

- (void)dejal_setValueForKey:(NSString *)key withDictionary:(NSDictionary *)dict;
- (void)dejal_setValueForKey:(NSString *)key orDictKey:(NSString *)altKey withDictionary:(NSDictionary *)dict;
- (void)dejal_setValueForKey:(NSString *)key orDictKeys:(NSArray *)altKeys withDictionary:(NSDictionary *)dict;

- (void)dejal_setValueInDictionary:(NSMutableDictionary *)dict forKey:(NSString *)key;
- (void)dejal_setValueInDictionary:(NSMutableDictionary *)dict forKey:(NSString *)key removeIfNil:(BOOL)removeIfNil;

- (BOOL)dejal_isReallySubclassOfClass:(Class)aClass;

- (BOOL)dejal_isEquivalent:(id)anObject;
- (BOOL)dejal_isEquivalentTo:(id)anObject;

- (BOOL)dejal_performBoolSelector:(SEL)selector;
- (BOOL)dejal_performBoolSelector:(SEL)selector withObject:(__unsafe_unretained id)object;
- (BOOL)dejal_performBoolSelector:(SEL)selector withObject:(__unsafe_unretained id)object1 withObject:(__unsafe_unretained id)object2;

- (NSInteger)dejal_performIntegerSelector:(SEL)selector;
- (NSInteger)dejal_performIntegerSelector:(SEL)selector withObject:(__unsafe_unretained id)object;
- (NSInteger)dejal_performIntegerSelector:(SEL)selector withObject:(__unsafe_unretained id)object1 withObject:(__unsafe_unretained id)object2;

- (void)dejal_performSelector:(SEL)selector withArguments:(NSArray *)arguments;

- (void)dejal_performSelector:(SEL)selector withEachObjectInArray:(NSArray *)array;
- (void)dejal_performSelector:(SEL)selector withEachObjectInDictionary:(NSDictionary *)dict;
- (void)dejal_performSelector:(SEL)selector withEachObjectInSet:(NSSet *)set;

@end

