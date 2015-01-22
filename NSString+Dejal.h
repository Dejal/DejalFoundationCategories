//
//  NSString+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Sat Aug 17 2002.
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


@interface NSString (Dejal)

+ (NSString *)dejal_stringWithIntegerValue:(NSInteger)value;
+ (NSString *)dejal_stringWithFloatValue:(CGFloat)value places:(NSInteger)places;
+ (NSString *)dejal_stringWithTruncatedFloatValue:(CGFloat)value;

+ (NSString *)dejal_stringWithIntegerValue:(NSInteger)value zero:(NSString *)zero singluar:(NSString *)singular plural:(NSString *)plural;

+ (NSString *)dejal_stringWithFloatValue:(CGFloat)value zero:(NSString *)zero singluar:(NSString *)singular plural:(NSString *)plural;

+ (NSString *)dejal_stringWithTimeInterval:(NSTimeInterval)seconds;
+ (NSString *)dejal_stringWithTimeInterval:(NSTimeInterval)seconds suffix:(NSString *)suffix;

+ (NSString *)dejal_stringWithRoundedTimeInterval:(NSTimeInterval)seconds suffix:(NSString *)suffix;

+ (NSString *)dejal_stringWithSeconds:(NSInteger)seconds minuteSingular:(NSString *)minuteSingular minutesPlural:(NSString *)minutesPlural secondSingular:(NSString *)secondSingular secondsPlural:(NSString *)secondsPlural;

+ (NSString *)dejal_stringWithIntegerValue:(NSInteger)value minimumLength:(NSUInteger)minLength paddedWith:(NSString *)padding padLeft:(BOOL)padLeft;

+ (NSString *)dejal_stringWithLeadingZeroesForIntegerValue:(NSInteger)value digits:(NSInteger)digits;

+ (NSString *)dejal_stringAsBytesWithInteger:(NSInteger)bytes;

+ (NSString *)dejal_stringWithPrefix:(NSString *)prefix keyword:(NSString *)keyword suffix:(NSString *)suffix or:(NSString *)alternative;

- (id)dejal_or:(id)preferred;
- (NSString *)dejal_indexedBy:(NSUInteger)idx;

- (BOOL)dejal_containsSomething;

//- (BOOL)dejal_containsString:(NSString *)subString;
//- (BOOL)dejal_containsStringCaseInsensitive:(NSString *)subString;

- (NSComparisonResult)dejal_caseAndSpaceInsensitiveCompare:(NSString *)otherString;

- (NSString *)dejal_lowercasedLettersOnly;
- (NSString *)dejal_lowercasedLettersOrDigitsOnly;
- (BOOL)dejal_containsStringLetters:(NSString *)otherString;
- (BOOL)dejal_isLetterEquivalentToString:(NSString *)otherString;

- (NSString *)dejal_stringByRemovingCharactersInSet:(NSCharacterSet *)set;
- (NSString *)dejal_stringByRemovingDiacriticalMarks;
- (NSString *)dejal_stringByRemovingQuotesAndSpaces;

- (NSString *)dejal_stringByRemovingPrefix:(NSString *)prefix;
- (NSString *)dejal_stringByRemovingSuffix:(NSString *)suffix;

- (NSString *)dejal_stringByDeletingLeadingSpaces:(BOOL)leading trailingSpaces:(BOOL)trailing;

- (NSString *)dejal_stringWithMinimumLength:(NSUInteger)minLength paddedWith:(NSString *)padding padLeft:(BOOL)padLeft;

- (NSArray *)dejal_componentsSeparatedByLength:(NSUInteger)length;
+ (NSUInteger)dejal_lengthOfInteger:(NSInteger)integer;

- (NSInteger)dejal_signedLength;
- (NSInteger)dejal_wordCount;

- (NSDictionary *)dejal_dictionaryWithVersionComponents;
+ (NSString *)dejal_versionWithDictionary:(NSDictionary *)dict;
+ (NSString *)dejal_versionWithMajor:(NSInteger)major minor:(NSInteger)minor bug:(NSInteger)bug kind:(NSString *)kind stage:(NSInteger)stage;

- (NSString *)dejal_left:(NSInteger)length;
- (NSString *)dejal_right:(NSInteger)length;

- (NSString *)dejal_from:(NSUInteger)position length:(NSUInteger)length;
- (NSString *)dejal_from:(NSUInteger)startPosition to:(NSUInteger)endPosition;

- (NSString *)dejal_substringFromString:(NSString *)string;
- (NSString *)dejal_substringToString:(NSString *)string;
- (NSString *)dejal_substringFromString:(NSString *)startString toString:(NSString *)endString defaultString:(NSString *)defaultString;

- (NSRange)dejal_rangeFromString:(NSString *)startString toString:(NSString *)endString;
- (NSRange)dejal_rangeFromString:(NSString *)startString toString:(NSString *)endString inclusive:(BOOL)inclusive;

- (NSString *)dejal_reverse;

- (NSUInteger)dejal_checksum;

- (NSString *)dejal_mask;
- (NSString *)dejal_unmask;

- (NSString *)dejal_encodeAsBase64UsingEncoding:(NSStringEncoding)encoding;
- (NSString *)dejal_decodeFromBase64UsingEncoding:(NSStringEncoding)encoding;

- (NSString *)dejal_rotate13;

+ (NSString *)dejal_uuid;

- (NSInteger)dejal_integerMappedFromString:(NSString *)value withDefault:(NSInteger)defaultValue;
- (NSString *)dejal_stringMappedFromInteger:(NSInteger)value withDefault:(NSString *)defaultValue;
- (NSString *)dejal_mappedFromValue:(id)value withDefault:(id)defaultValue;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSString (DejalInternet)

- (NSString *)dejal_stringByReplacingPercentEscapes;
- (NSString *)dejal_stringByAddingPercentEscapes;

- (NSString *)dejal_stringByMakingURLSafe;

- (NSString *)dejal_stringByStrippingHTML;

- (NSString *)dejal_stringByCleaningURL;
- (NSString *)dejal_stringByCleaningURLWithDefaultScheme:(NSString *)scheme;

- (NSURL *)dejal_urlValue;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSString (DejalFilePath)

- (NSString *)dejal_stringByCleaningFilenameWithDefault:(NSString *)defaultFilename;
- (NSString *)dejal_stringByAppendingPathComponent:(NSString *)dirtyFilename cleanWithDefault:(NSString *)defaultFilename;

- (NSString *)dejal_lastPathComponentWithoutExtension;

- (NSString *)dejal_backupFilePath;

- (NSString *)dejal_uniquePath;
- (NSString *)dejal_uniquePathWithPrefix:(NSString *)prefix;

- (NSString *)dejal_validatedDirectoryPath;
- (NSString *)dejal_validatedFilePath;

- (NSString *)dejal_expandedPath;
- (NSString *)dejal_abbreviatedPath;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSString (DejalPropertyList)

+ (NSString *)dejal_stringWithBoolValue:(BOOL)value;

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@interface NSMutableString (Dejal)

- (void)dejal_deleteCharactersInSet:(NSCharacterSet *)set;

- (void)dejal_caseInsensitiveReplaceAllOccurrencesOf:(NSString *)string1 with:(NSString *)string2;
- (void)dejal_replaceAllOccurrencesOf:(NSString *)string1 with:(NSString *)string2;

- (void)dejal_deleteLeadingSpaces:(BOOL)leading trailingSpaces:(BOOL)trailing;

- (void)dejal_appendString:(NSString *)string or:(NSString *)alternative;
- (void)dejal_appendPrefix:(NSString *)prefix keyword:(NSString *)keyword;
- (void)dejal_appendPrefix:(NSString *)prefix keyword:(NSString *)keyword suffix:(NSString *)suffix or:(NSString *)alternative;
- (void)dejal_appendSeparator:(NSString *)separator prefix:(NSString *)prefix keyword:(NSString *)keyword suffix:(NSString *)suffix  or:(NSString *)alternative;

@end

