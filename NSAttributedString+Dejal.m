//
//  NSAttributedString+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Fri Jul 18 2003.
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


#import "NSAttributedString+Dejal.h"
#import "NSString+Dejal.h"


@implementation NSAttributedString (Dejal)

/**
 Convenience method to create and return an empty, autoreleased attributed string.
 
 @author DJS 2003-07.
*/

+ (instancetype)dejal_attributedString;
{
    return [[self alloc] initWithString:@""];
}

/**
 Convenience method to create and return an autoreleased attributed string from the specified string.

 @author DJS 2003-07.
*/

+ (instancetype)dejal_attributedStringWithString:(NSString *)string;
{
    return [[self alloc] initWithString:string];
}

/**
 Convenience method to create and return an autoreleased attributed string from the specified string and attributes.
 
 @author DJS 2004-10.
*/

+ (instancetype)dejal_attributedStringWithString:(NSString *)string attributes:(NSDictionary *)attributes
{
    return [[self alloc] initWithString:string attributes:attributes];
}

/**
 Returns a new attributed string instance from a string in RTF format.
 
 @param rtfString A string containing RTF format.
 @returns The corresponding attributed string.
 
 @author DJS 2014-04.
 */

+ (instancetype)dejal_attributedStringWithRTFString:(NSString *)rtfString;
{
    return [self dejal_attributedStringWithRTFData:[rtfString dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 Returns a new attributed string instance from data in RTF format.
 
 @param rtfData Data containing RTF format.
 @returns The corresponding attributed string.
 
 @author DJS 2014-04.
 */

+ (instancetype)dejal_attributedStringWithRTFData:(NSData *)rtfData;
{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    NSAttributedString *attrib = [[self alloc] initWithData:rtfData options:options documentAttributes:nil error:nil];
    
    return attrib;
}

/**
 Returnss a string containing a RTF format representation of the receiver.
 
 @author DJS 2014-04.
 */

- (NSString *)dejal_rtfString;
{
    NSData *data = [self dejal_rtfData];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

/**
 Returnss data containing a RTF format representation of the receiver.
 
 @author DJS 2014-04.
 */

- (NSData *)dejal_rtfData;
{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    NSData *data = [self dataFromRange:NSMakeRange(0, [self length]) documentAttributes:options error: nil];
    
    return data;
}

/**
 Returns a range enclosing the entire attributed string.
 
 @author DJS 2004-12.
*/

- (NSRange)dejal_allRange;
{
    return NSMakeRange(0, [self length]);
}

/**
 Adjusts the font size of all text in the indicated range text by the specified amount.
 
 @param offsetPoints A positive number to increase the font size by that many points, or a negative number to decrease it.
 @param range The range to adjust (use -allRange to adjust the entire string).
 @returns A new attributed string with the adjusted text.
 
 @author DJS 2014-04.
 @version DJS 2014-12: Added Mac support.
 */

- (NSAttributedString *)dejal_attributedStringWithFontSizeAdjustmentOffset:(CGFloat)offsetPoints inRange:(NSRange)range;
{
    NSMutableAttributedString *mutie = [self mutableCopy];
    
    [mutie beginEditing];
    
    [mutie enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(id attribute, NSRange attributeRange, BOOL *stop)
     {
        if (attribute)
        {
#if TARGET_OS_IPHONE
            UIFont *oldFont = (UIFont *)attribute;
            UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize + offsetPoints];
#else
            NSFont *oldFont = (NSFont *)attribute;
            NSFont *newFont = [NSFont fontWithName:oldFont.fontName size:oldFont.pointSize + offsetPoints];
#endif
            
            [mutie removeAttribute:NSFontAttributeName range:attributeRange];
            [mutie addAttribute:NSFontAttributeName value:newFont range:attributeRange];
        }
    }];
    
    [mutie endEditing];
    
    return mutie;
}

/**
 Adjusts the font size of all text in the indicated range text to twice as large, or half as large.
 
 @param increase If YES, the fonts are doubled in size; if NO, they are halved.
 @param range The range to adjust (use -allRange to adjust the entire string).
 @returns A new attributed string with the adjusted text.
 
 @author DJS 2014-04.
 @version DJS 2014-12: Added Mac support.
 */

- (NSAttributedString *)dejal_attributedStringWithFontSizeIncrease:(BOOL)increase inRange:(NSRange)range;
{
    NSMutableAttributedString *mutie = [self mutableCopy];
    
    [mutie beginEditing];
    
    [mutie enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(id attribute, NSRange attributeRange, BOOL *stop)
     {
        if (attribute)
        {
            CGFloat factor = increase ? 2.0 : 0.5;
            
#if TARGET_OS_IPHONE
            UIFont *oldFont = (UIFont *)attribute;
            UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize * factor];
#else
            NSFont *oldFont = (NSFont *)attribute;
            NSFont *newFont = [NSFont fontWithName:oldFont.fontName size:oldFont.pointSize * factor];
#endif
            
            [mutie removeAttribute:NSFontAttributeName range:attributeRange];
            [mutie addAttribute:NSFontAttributeName value:newFont range:attributeRange];
        }
    }];
    
    [mutie endEditing];
    
    return mutie;
}

@end


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------


@implementation NSMutableAttributedString (Dejal)

/**
 Appends the string to the receiver, using the specified attributes.
 
 @author DJS 2007-02.
*/

- (void)dejal_appendString:(NSString *)string withAttributes:(NSDictionary *)attributes;
{
    [self appendAttributedString:[[self class] dejal_attributedStringWithString:string attributes:attributes]];
}

/**
 Inserts the string into the receiver at the index position, using the specified attributes.
 
 @author DJS 2007-02.
*/

- (void)dejal_insertString:(NSString *)string withAttributes:(NSDictionary *)attributes atIndex:(NSUInteger)i;
{
    [self insertAttributedString:[[self class] dejal_attributedStringWithString:string attributes:attributes] atIndex:i];
}

@end

