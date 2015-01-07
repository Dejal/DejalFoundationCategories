//
//  NSArray+Dejal.m
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

#import "NSArray+Dejal.h"
#import "NSObject+Dejal.h"


@implementation NSArray (Dejal)

/**
 Returns YES if the index is in the acceptable range for the receiver, or NO if not.  If using the index with -objectAtIndex: or similar when this returns NO, you'll get an exception.
 
 @author DJS 2003-11.
*/

- (BOOL)dejal_isValidIndex:(NSUInteger)i
{
    return (i < [self count]);
}

// See <http://www.macdevcenter.com/pub/a/mac/2004/07/16/hom.html> for an interesting technique to do something similar to the following methods.

/**
 Returns the first dictionary object where the value for the specified key is equivalent to the match value (see -isEquivalentTo:), or nil if none do.  Useful for the common pattern of finding an object based on a dictionary value.  See also -indexOfObjectMatching:usingKey:, -objectMatching:usingSelector:, and -arrayWithObjectsMatching:usingKey:, below.
 
 @author DJS 2004-04.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (id)dejal_objectMatching:(id)match usingKey:(NSString *)key;
{
    __block id foundObject = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj respondsToSelector:@selector(objectForKey:)] && [obj[key] dejal_isEquivalentTo:match])
         {
             foundObject = obj;
             *stop = YES;
         }
     }];
    
    return foundObject;
}

/**
 Returns the index of the first dictionary object where the value for the specified key is equivalent to the match value (see -isEquivalentTo:), or NSNotFound if none do.  Useful for the common pattern of finding the index of an object based on a dictionary value.  See also -objectMatching:usingKey:, above, and -arrayWithObjectsMatching:usingKey:, below.
 
 @author DJS 2004-04.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (NSUInteger)dejal_indexOfObjectMatching:(id)match usingKey:(NSString *)key
{
    return [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
     {
         return [obj respondsToSelector:@selector(objectForKey:)] && [obj[key] dejal_isEquivalentTo:match];
     }];
}

/**
 Returns the first object where the specified selector's return value is equivalent to the match value (see -isEquivalentTo:), or nil if none do.  Useful for the common pattern of finding an object based on an accessor value.  See also arrayWithObjectsMatching:usingSelector:, below.
 
 @author DJS 2004-02.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (id)dejal_objectMatching:(id)match usingSelector:(SEL)selector;
{
    __block id foundObject = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
        if ([[obj performSelector:selector] dejal_isEquivalentTo:match])
        {
            foundObject = obj;
            *stop = YES;
        }
     }];
    
    return foundObject;
}

/**
 Returns the first object where the specified selector's return value is equivalent to the match value (see -isEquivalentTo:).  If none do, but a default match value was specified and an object matching that was found, it is returned instead.  If not, but firstIfNotFound is YES, the first object is returned.  Otherwise nil is returned.  Useful for the common pattern of finding an object based on an accessor value, and handling default cases.  See also objectMatching:usingSelector:, above.
 
 @author DJS 2004-06.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (id)dejal_objectMatching:(id)match orDefault:(id)defaultMatch orFirst:(BOOL)firstIfNotFound usingSelector:(SEL)selector
{
    if (!match && !defaultMatch && !firstIfNotFound)
    {
        // Short-circuit:
        return nil;
    }
    
    __block id foundObject = nil;
    __block id defaultObject = nil;
    __block id firstObject = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         id result = [obj performSelector:selector];
         
         // Is it the one we want?
         if ([result dejal_isEquivalentTo:match])
         {
             foundObject = obj;
             *stop = YES;
         }
         
         // Is a default match specified, and is it that one?
         if (defaultMatch && [result dejal_isEquivalentTo:defaultMatch])
         {
             defaultObject = obj;
         }
         
         // Have we not noted the first one yet, and do we care?
         if (!firstObject && firstIfNotFound)
         {
             firstObject = obj;
         }
     }];
    
    if (foundObject)
    {
        return foundObject;
    }
    else if (defaultObject)
    {
        return defaultObject;
    }
    else if (firstObject)
    {
        return firstObject;
    }
    
    return nil;
}

/**
 Returns a new array of all objects that respond to -objectForKey: and that method's return value is equivalent to the match value (see -isEquivalentTo:).  If none do, an empty array is returned.  Useful for the common pattern of finding objects in an array of dictionaries.  See also -objectMatching:usingKey: and -arrayWithObjectsMatching:usingSelector:, above.
 
 @author DJS 2005-03.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (NSArray *)dejal_arrayWithObjectsMatching:(id)match usingKey:(NSString *)key
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj respondsToSelector:@selector(objectForKey:)] && [obj[key] dejal_isEquivalentTo:match])
         {
             [array addObject:obj];
         }
     }];
    
    return array;
}

/**
 Returns a new array of all objects where the specified selector's return value is equivalent to the match value (see -isEquivalentTo:).  If none do, an empty array is returned.  Useful for the common pattern of finding objects based on an accessor value.  See also -objectMatching:usingSelector:, above, and -arrayWithObjectsMatching:usingKey:, below.
 
 @author DJS 2004-02.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (NSArray *)dejal_arrayWithObjectsMatching:(id)match usingSelector:(SEL)selector
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([[obj performSelector:selector] dejal_isEquivalentTo:match])
         {
             [array addObject:obj];
         }
     }];
    
    return array;
}

/**
 Returns a new array containing the values returned by the specified selector for each object in the receiver.  The selector would normally be an accessor, and must take no parameters and return an object value.
 
 @author DJS 2004-02.
 @version DJS 2014-09: changed to use block enumeration instead of NSEnumerator.
*/

- (NSArray *)dejal_arrayUsingSelector:(SEL)selector
{
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [array addObject:[obj performSelector:selector]];
     }];
    
    return array;
}

/**
 Returns a new array containing all objects of the receiver other than the specified one.
 
 @author DJS 2010-07.
*/

- (NSArray *)dejal_arrayByRemovingObject:(id)object;
{
    NSMutableArray *array = [self mutableCopy];
    
    [array removeObject:object];
    
    return array;
}

/**
 Returns a new array containing all objects of the receiver other than the specified one.
 
 @author DJS 2010-07.
*/

- (NSArray *)dejal_arrayByRemovingObjectAtIndex:(NSUInteger)idx;
{
    NSMutableArray *array = [self mutableCopy];
    
    [array removeObjectAtIndex:idx];
    
    return array;
}

/**
 Returns a new array containing only the objects from the receiver that are not also in the other array.
 
 @author DJS 2004-04.
*/

- (NSArray *)dejal_arrayByRemovingObjectsInArray:(NSArray *)otherArray
{
    NSMutableArray *array = [self mutableCopy];
    
    [array removeObjectsInArray:otherArray];
    
    return array;
}

/**
 Returns a reversed edition of the reciever.
 
 @author DJS 2004-03.
 @version DJS 2014-10: changed to use a modern block approach.
*/

- (NSArray *)dejal_reverseArray;
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [array addObject:obj];
     }];
    
    return array;
}

/**
 Returns a copy of the receiver sorted as in the Finder.
 
 @author DJS 2008-01.
*/

- (NSArray *)dejal_sortedArrayUsingFinderOrder;
{
    return [self sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

/**
 Given a property key (i.e. an accessor name), returns the receiver sorted by that value.  (If the values of the key are not likely to be unique, it'd be better to do this manually, to sort on two keys, and thus avoid random ordering of same primary values.)
 
 @author DJS 2010-10.
*/

- (NSArray *)dejal_sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending;
{
    return [self sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]]];
}

/**
 Returns YES if the object is already in the array.
*/

- (BOOL)dejal_containsObjectIdenticalTo:(id)obj
{
    return [self indexOfObjectIdenticalTo:obj] != NSNotFound;
}

/**
 Returns YES if the receiver contains an object that is equivalent to the specified one.  See -isEquivalentTo:.
 
 @author DJS 2005-05.
*/

- (BOOL)dejal_containsObjectEquivalentTo:(id)obj
{
    return [self dejal_indexOfObjectEquivalentTo:obj] != NSNotFound;
}

/**
 Returns the index of the first object in the receiver that is equivalent to the specified one.  If none is found, returns NSNotFound.  See -isEquivalentTo:.
 
 @author DJS 2005-05.
*/

- (NSUInteger)dejal_indexOfObjectEquivalentTo:(id)obj
{
    NSUInteger i = 0;
    id object = nil;
    BOOL found = NO;
    
    while (!found && i < [self count])
    {
        if ((object = self[i]))
            found = [object dejal_isEquivalentTo:obj];
        
        if (!found)
            i++;
    }
    
    if (found)
        return i;
    else
        return NSNotFound;
}

/**
 Returns the first object in the array that passes a test in a given block.
 
 @param predicate The block to apply to elements in the array.
 @returns The first object in the receiver that passes the test specified by the predicate.  If no objects pass the test, returns nil..
 
 @author DJS 2014-10.
 */

- (id)dejal_objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
{
    __block id foundObject = nil;
    
    [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
     {
         if (predicate(obj, idx, stop))
         {
             foundObject = obj;
             return YES;
         }
         
         return NO;
     }];
    
    return foundObject;
}

/**
 Returns the second-to-last object in the array, or nil if the array is empty or only contains one object.
 
 @author DJS 2003-06.
*/

- (id)dejal_penultimateObject
{
    NSUInteger numberOfItems = [self count];
    
    if (numberOfItems >= 2)
        return self[numberOfItems - 2];
    else
        return nil;
}

/**
 Similar to -copy, but each of the objects in the array are copied too.  Note that like -copy, the array is retained.
 
 @author DJS 2004-06.
 @version DJS 2006-01: changed to fix memory leak through excessive retaining.
*/

- (id)dejal_deepCopy
{
    id array = [[NSMutableArray alloc] init];
    id copy;
    
    for (id object in self)
    {
        if ([object respondsToSelector:@selector(dejal_deepCopy)])
            copy = [object dejal_deepCopy];
        else
            copy = [object copy];
        
    	[array addObject:copy];
    }
    
    return array;
}

/**
 Similar to -deepCopy, above, but makes all of the contents of the dictionary mutable.
 
 @author DJS 2009-01.
 */

- (id)dejal_deepMutableCopy;
{
    id array = [[NSMutableArray alloc] init];
    id mutableCopy;
    
    for (id object in self)
    {
        if ([object respondsToSelector:@selector(dejal_deepMutableCopy)])
            mutableCopy = [object dejal_deepMutableCopy];
        else if ([object conformsToProtocol:@protocol(NSMutableCopying)])
            mutableCopy = [object mutableCopy];
        else
            mutableCopy = [object copy];
        
    	[array addObject:mutableCopy];
    }
    
    return array;
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSMutableArray (Dejal)

/**
 Similar to -insertObject:atIndex:, but if the index is out of range, it inserts at the end (if atEnd is YES) or at the start (if atEnd is NO), rather than giving an exception.  Returns the index the object was inserted at.
 
 @author DJS 2004-01.
*/

- (NSUInteger)dejal_insertObject:(id)object atIndex:(NSUInteger)i orEnd:(BOOL)atEnd
{
    NSUInteger count = [self count];
    
    // Remember that the index can equal count for -insertObject:atIndex: -- that just means to insert afterwards, but check for it here in case atEnd is NO:
    if (i > count)
    {
        if (atEnd)
            i = count;
        else
            i = 0;
    }
    
    [self insertObject:object atIndex:i];
    
    return i;
}

/**
 Similar to -insertObject:atIndex:, but inserts multiple objects at the index position.
*/

- (void)dejal_insertObjectsFromArray:(NSArray *)array atIndex:(NSUInteger)i
{
    id object;
    
    for (object in array)
    {
        [self insertObject:object atIndex:i++];
    }
}

/**
 Inserts objects from the specified array at the index position, removing them from their old position if already present.  If the index is invalid, the objects are added to the array (instead of causing an exception).  The adjusted index is returned; it is adjusted if some old indexes were before the new index.
 
 @author DJS 2003-11.
 @version DJS 2007-04: changed to return the adjusted index.
*/

- (NSUInteger)dejal_insertOrMoveObjectsFromArray:(NSArray *)array atIndex:(NSUInteger)i;
{
    id object;
    
    for (object in array)
    {
        NSUInteger existing = [self indexOfObject:object];
        
        if (existing != NSNotFound)
        {
            if (existing < i)
                i--;
            
            [self removeObjectAtIndex:existing];
        }
    }
    
    if ([self dejal_isValidIndex:i])
        [self dejal_insertObjectsFromArray:array atIndex:i];
    else
    {
        i = [array count];
        [self addObjectsFromArray:array];
    }
    
    return i;
}

/**
 Adds objects from the specified array, removing them from their old position if already present.
 
 @author DJS 2003-11.
*/

- (void)dejal_addOrMoveObjectsFromArray:(NSArray *)array
{
    [self dejal_insertOrMoveObjectsFromArray:array atIndex:-1];
}

/**
 Given an enumerator for an array of index numbers (e.g. as used in NSTableView's -selectedRowsEnumerator), this returns a new mutable array containing the corresponding objects from the receiver.
 
 @author DJS 2004-01.
*/

- (NSMutableArray *)dejal_arrayWithIndexEnumerator:(NSEnumerator *)enumerator
{
    NSMutableArray *array = [NSMutableArray array];
    NSNumber *i;
    
    while ((i = [enumerator nextObject]))
    {
        id object = self[[i integerValue]];
        
        if (object)
            [array addObject:object];
    }
    
    return array;
}

/**
 Given an enumerator for an array of index numbers (e.g. as returned by -[NSTableView selectedRowsEnumerator]), this removes the corresponding objects from the receiver.
 
 @author DJS 2004-01.
*/

- (void)dejal_removeObjectsFromIndexEnumerator:(NSEnumerator *)enumerator
{
    [self removeObjectsInArray:[self dejal_arrayWithIndexEnumerator:enumerator]];
}

/**
 Given a value to match and a key to use to find that value, this removes the corresponding objects from the receiver.  Useful for removing all dictionaries in an array that have the match value.
 
 @author DJS 2005-03.
*/

- (void)dejal_removeObjectsMatching:(id)match usingKey:(NSString *)key
{
    [self removeObjectsInArray:[self dejal_arrayWithObjectsMatching:match usingKey:key]];
}

/**
 Returns a mutable reversed edition of the reciever.
 
 @author DJS 2004-03.
*/

- (NSMutableArray *)dejal_reverseArray
{
    return [[super dejal_reverseArray] mutableCopy];
}

/**
 Makes an immutable copy of the receiver, then sends the selector to each object in the array.  This should be used instead of -makeObjectsPerformSelector: for mutable arrays, since they could raise an exception if the array is mutated during enumeration (e.g. as a side-effect of the selector method).
 
 @author DJS 2011-04.
*/

- (void)dejal_makeObjectsSafelyPerformSelector:(SEL)selector;
{
    NSArray *immutableArray = [self copy];
    
    [immutableArray makeObjectsPerformSelector:selector];
}

/**
 Convenience method to use a mutable array as a queue; adds the object to the end of the queue.
 
 @author DJS 2014-04.
 */

- (void)dejal_enqueue:(id)obj;
{
    [self addObject:obj];
}

/**
 Convenience method to use a mutable array as a queue; removes the first object from the queue and returns it.
 
 @author DJS 2014-04.
 */

- (id)dejal_dequeue;
{
    id first = [self firstObject];
    
    if (first)
        [self removeObjectAtIndex:0];
    
    return first;
}

/**
 Convenience method to use a mutable array as a stack; adds the object to the top (end) of the stack.
 
 @author DJS 2014-04.
 */

- (void)dejal_push:(id)obj;
{
    [self addObject:obj];
}

/**
 Convenience method to use a mutable array as a stack; removes the top (end) object from the stack and returns it.
 
 @author DJS 2014-04.
 */

- (id)dejal_pop;
{
    id last = [self lastObject];
    
    if (last)
        [self removeLastObject];
    
    return last;
}

@end

