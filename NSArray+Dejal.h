//
//  NSArray+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri May 30 2003.
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

@import Foundation;


@interface NSArray (Dejal)

- (BOOL)dejal_isValidIndex:(NSUInteger)i;

- (id)dejal_objectMatching:(id)match usingKey:(NSString *)key;
- (NSUInteger)dejal_indexOfObjectMatching:(id)match usingKey:(NSString *)key;

- (id)dejal_objectMatching:(id)match usingSelector:(SEL)selector;
- (id)dejal_objectMatching:(id)match orDefault:(id)defaultMatch orFirst:(BOOL)firstIfNotFound usingSelector:(SEL)selector;

- (NSArray *)dejal_arrayWithObjectsMatching:(id)match usingKey:(NSString *)key;
- (NSArray *)dejal_arrayWithObjectsMatching:(id)match usingSelector:(SEL)selector;

- (NSArray *)dejal_arrayUsingSelector:(SEL)selector;

- (NSArray *)dejal_arrayByRemovingObject:(id)object;
- (NSArray *)dejal_arrayByRemovingObjectAtIndex:(NSUInteger)idx;
- (NSArray *)dejal_arrayByRemovingObjectsInArray:(NSArray *)otherArray;

- (NSArray *)dejal_reverseArray;

- (NSArray *)dejal_sortedArrayUsingFinderOrder;
- (NSArray *)dejal_sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending;

- (BOOL)dejal_containsObjectIdenticalTo:(id)obj;
- (BOOL)dejal_containsObjectEquivalentTo:(id)obj;
- (NSUInteger)dejal_indexOfObjectEquivalentTo:(id)obj;

- (id)dejal_objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (id)dejal_penultimateObject;

- (id)dejal_deepCopy NS_RETURNS_RETAINED;
- (id)dejal_deepMutableCopy NS_RETURNS_RETAINED;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSMutableArray (Dejal)

- (NSUInteger)dejal_insertObject:(id)object atIndex:(NSUInteger)i orEnd:(BOOL)atEnd;
- (void)dejal_insertObjectsFromArray:(NSArray *)array atIndex:(NSUInteger)i;
- (NSUInteger)dejal_insertOrMoveObjectsFromArray:(NSArray *)array atIndex:(NSUInteger)i;
- (void)dejal_addOrMoveObjectsFromArray:(NSArray *)array;

- (NSMutableArray *)dejal_arrayWithIndexEnumerator:(NSEnumerator *)enumerator;

- (void)dejal_removeObjectsFromIndexEnumerator:(NSEnumerator *)enumerator;
- (void)dejal_removeObjectsMatching:(id)match usingKey:(NSString *)key;

- (NSMutableArray *)dejal_reverseArray;

- (void)dejal_makeObjectsSafelyPerformSelector:(SEL)selector;

- (void)dejal_enqueue:(id)obj;
- (id)dejal_dequeue;

- (void)dejal_push:(id)obj;
- (id)dejal_pop;

@end

