//
//  NSData+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri Jan 02 2004.
//  Copyright (c) 2004-2015 Dejal Systems, LLC. All rights reserved.
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

#import "NSData+Dejal.h"


@implementation NSData (Dejal)

/**
 Returns an archived rendition of the object (which can be any object that conforms to NSCoding, e.g. a dictionary or array with simple Cocoa objects).  Use -object, below, to unarchive the object.  Provided as a convenience, as this functionality seems more logical (to me anyway) as part of NSData.
 
 @author DJS 2004-01.
 @version DJS 2012-11: changed to use a keyed archiver on iOS; continues to use a non-keyed archiver on Mac, for backwards compatibility.
*/

+ (NSData *)dejal_dataWithObject:(id)rootObject;
{
#if TARGET_OS_IPHONE
    return [NSKeyedArchiver archivedDataWithRootObject:rootObject];
#else
    return [NSArchiver archivedDataWithRootObject:rootObject];
#endif
}

/**
 Returns the object rendition of the archived data.  Use this to balance +dataWithObject:, above.  Provided as a convenience, as this functionality seems more logical (to me anyway) as part of NSData.
 
 @author DJS 2004-01.
 @version DJS 2012-11: changed to use a keyed unarchiver on iOS; continues to use a non-keyed unarchiver on Mac, for backwards compatibility.
*/

- (id)dejal_object;
{
#if TARGET_OS_IPHONE
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
#else
    return [NSUnarchiver unarchiveObjectWithData:self];
#endif
}

@end

