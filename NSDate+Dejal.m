//
//  NSDate+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Thu Apr 17 2003.
//  Copyright (c) 2003-2015 Dejal Systems, LLC. All rights reserved.
//
//  Portions originally by Jeff LaMarche: <http://iphonedevelopment.blogspot.com/2009/07/category-on-nsdate.html>
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

#import "NSDate+Dejal.h"
#import "NSString+Dejal.h"


@implementation NSDate (Dejal)

/**
 Singleton method to return the Gregorian calendar, creating it if necessary.
 
 @author DJS 2014-05.
 */

+ (NSCalendar *)dejal_gregorianCalendar;
{
    static id dejal_gregorianCalendar = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      dejal_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                  });
    
    return dejal_gregorianCalendar;
}

- (NSCalendar *)dejal_gregorianCalendar;
{
    return [[self class] dejal_gregorianCalendar];
}

/**
 Returns a date representation of the specified year, month and day, with the time set to midnight, using the Gregorian calendar.  If localTimeZone is YES, the current local time zone is used, otherwise GMT is used.
 
 @author DJS 2013-02.
*/

+ (NSDate *)dejal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day localTimeZone:(BOOL)localTimeZone;
{
    return [self dejal_dateWithYear:year month:month day:day hour:0 minute:0 second:0 localTimeZone:localTimeZone];
}

/**
 Returns a date representation of the specified year, month, day, hour, minute and second, using the Gregorian calendar.  If localTimeZone is YES, the current local time zone is used, otherwise GMT is used.
 
 @author DJS 2013-02.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

+ (NSDate *)dejal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second localTimeZone:(BOOL)localTimeZone;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    if (localTimeZone)
        [components setTimeZone:[NSTimeZone defaultTimeZone]];
    else
        [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    return [gregorian dateFromComponents:components];
}

/**
 Given a date as a string, returns a new date representation, or nil if the string is nil or empty.
 
 @author DJS 2009-09.
*/

+ (NSDate *)dejal_dateWithString:(NSString *)string;
{
    if (!string.length)
        return nil;

    NSDateFormatter *formatter = [NSDateFormatter new];
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

/**
 Given a date as a string, plus a date format string, returns a new date representation, or nil if the string is nil or empty.
 
 @author DJS 2009-09.
 @version DJS 2010-02: changed to set the locale too.
*/

+ (NSDate *)dejal_dateWithString:(NSString *)string format:(NSString *)format;
{
    if (!string.length)
        return nil;
    
    NSDateFormatter *formatter = [NSDateFormatter new];

    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
	
    if (format)
        [formatter setDateFormat:format];

    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

/**
 Returns the receiver as a string in the specified format.
 
 @author DJS 2012-05.
*/

- (NSString *)dejal_stringWithFormat:(NSString *)format;
{
    NSDateFormatter *formatter = [NSDateFormatter new];

    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
	
    if (format)
        [formatter setDateFormat:format];

    return [formatter stringFromDate:self];
}

/**
 Singleton to return a date formatter for the RFC3339 standard internet date format.
 
 @author DJS 2012-04.
*/

+ (NSDateFormatter *)dejal_internetDateFormatter;
{
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    
    if (!sRFC3339DateFormatter)
    {
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        sRFC3339DateFormatter = [NSDateFormatter new];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];  //@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return sRFC3339DateFormatter;
}

/**
 Given a date as a string in either JSON format (e.g. "2008-05-13T17:54:02Z" or "/Date(1210701242578)/"), returns a date representation.  Does basic cleanup of a new format string.  Returns nil if the string is empty or not a string.
 
 @author DJS 2012-06.
*/

+ (NSDate *)dejal_dateWithJSONString:(NSString *)jsonDate;
{
    return [self dejal_dateWithJSONString:jsonDate allowPlaceholder:NO];
}

/**
 Given a date as a string in either JSON format (e.g. "2008-05-13T17:54:02Z" or "/Date(1210701242578)/"), returns a date representation.  Does basic cleanup of a new format string.  Returns nil if the string is empty or not a string.
 
 @author DJS 2012-01.
 @version DJS 2012-04: changed to support both old and new formats.
 @version DJS 2012-05: changed to return nil if the string is empty or not a string.
 @version DJS 2012-06: changed to optionally return nil if it's the 1899 placeholder date.
 @version DJS 2013-01: changed to avoid accidentially removing the "Z".
 @version DJS 2013-05: changed to add support for the 0001 placeholder date.
*/

+ (NSDate *)dejal_dateWithJSONString:(NSString *)jsonDate allowPlaceholder:(BOOL)allowPlaceholder;
{
    if (![jsonDate isKindOfClass:[NSString class]] || !jsonDate.length)
        return nil;
    else if (!allowPlaceholder && ([jsonDate hasPrefix:@"1899-12-30"] || [jsonDate hasPrefix:@"0001-01-01"]))
        return nil;
    else if ([jsonDate hasPrefix:@"/Date("])
    {
        NSString *string = [[jsonDate dejal_substringFromString:@"/Date("] dejal_substringToString:@")/"];
        NSTimeInterval interval = [string longLongValue] / 1000.0;
        
        return [NSDate dateWithTimeIntervalSince1970:interval];
    }
    else
    {
        BOOL isLocalTime = ![jsonDate hasSuffix:@"Z"];
        NSRange position = [jsonDate rangeOfString:@"."];
        
        if (position.location != NSNotFound)
            jsonDate = [jsonDate substringToIndex:position.location];
        
        if (![jsonDate hasSuffix:@"Z"])
            jsonDate = [jsonDate stringByAppendingString:@"Z"];
        
        NSDate *result = [[self dejal_internetDateFormatter] dateFromString:jsonDate];
        
        if (isLocalTime)
            result = [result dateByAddingTimeInterval:[self dejal_localTimeOffset]];
        
        return result;
    }
}

/**
 Returns the receiver represented as a new-style JSON-format date string.
 
 @author DJS 2012-04.
*/

- (NSString *)dejal_JSONStringValue;
{
    return [[NSDate dejal_internetDateFormatter] stringFromDate:self];
}

/**
 Returns the receiver represented as an old-style JSON-format date string.
 
 @author DJS 2012-01.
 @version DJS 2012-03: changed to use the local time zone.
 @version DJS 2012-04: changed to rename as -oldStyleJSONStringValue.
*/

- (NSString *)dejal_oldStyleJSONStringValue;
{
    NSTimeInterval timeZoneOffset = [NSDate dejal_localTimeOffset];
    NSTimeInterval base = [self timeIntervalSince1970] + timeZoneOffset;
    NSTimeInterval interval = base * 1000.0;
    NSString *string = [NSString stringWithFormat:@"/Date(%.0f)/", interval];
    
    return string;
}

/**
 Returns the interval to add to a local date to convert it to a UTC date, i.e. allowing for the current time zone and daylight saving time.
 
 @author DJS 2013-06.
*/

+ (NSTimeInterval)dejal_localTimeOffset;
{
    return -([[NSTimeZone defaultTimeZone] secondsFromGMT] - [[NSTimeZone defaultTimeZone] daylightSavingTimeOffset]);
}

/**
 Returns the current date without the time component.
 
 @author JLM 2009-07.
*/

+ (NSDate *)dejal_dateWithoutTime;
{
    return [[NSDate date] dejal_dateAsDateWithoutTime];
}

/**
 Returns the receiver without the time component (using noon as a placeholder time, so it's DST-proof).
 
 @author DJS 2009-07.
 @version DJS 2010-02: changed to set the locale too.
 @version DJS 2011-12: changed to use date components instead of a formatter, which always seemed like a hack.
 @version DJS 2014-05: changed to use noon instead of midnight, as recommended by Apple.
*/

- (NSDate *)dejal_dateAsDateWithoutTime;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSDate *midnight = [calendar dateFromComponents:components];
    
    components = [NSDateComponents new];
    [components setHour:12];
    
    return [calendar dateByAddingComponents:components toDate:midnight options:0];
}

/**
 Returns YES if the receiver has time components, or NO if it's just a date.  Note: this will return NO if the time is exactly midnight.
 
 @author DJS 2012-02.
*/

- (BOOL)dejal_includesTime;
{
    return ![self isEqualToDate:[self dejal_dateAsDateWithoutTime]];
}

/**
 Returns YES if the receiver is today's date.
 
 @author DJS 2011-12.
*/

- (BOOL)dejal_isToday;
{
    return ([[NSDate dejal_dateWithoutTime] isEqualToDate:[self dejal_dateAsDateWithoutTime]]);
}

/**
 Determines if a given date is within a certain number of days before to after the current date.  The time is ignored, so for example passing -1 for daysBefore will mean any time yesterday.
 
 @param date The date to be considered.
 @param daysBefore The number of days before today.
 @param daysAfter The number of days after today.
 @returns YES if the date is in the range, otherwise NO.
 
 @author DJS 2014-03.
 */

- (BOOL)dejal_isBetweenDaysBefore:(NSInteger)daysBefore daysAfter:(NSInteger)daysAfter;
{
    NSInteger diff = [[NSDate dejal_dateWithoutTime] dejal_differenceInDaysTo:[self dejal_dateAsDateWithoutTime]];
    BOOL want = NO;
    
    if (diff < 0)
        want = -diff <= daysBefore;
    else
        want = diff <= daysAfter;
    
//    NSLog(@"date: %@ isBetweenDaysBefore: %ld daysAfter: %ld: diff: %ld; want: %@", self, (long)daysBefore, (long)daysAfter, (long)diff, want ? @"yes" : @"no");  // log
    
    return want;
}

/**
 Returns the second of the receiver.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_second;
{
    return [self dejal_components:NSCalendarUnitSecond].second;
}

/**
 Returns the minute of the receiver.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_minute;
{
    return [self dejal_components:NSCalendarUnitMinute].minute;
}

/**
 Returns the hour of the receiver.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_hour;
{
    return [self dejal_components:NSCalendarUnitHour].hour;
}

/**
 Returns the day of the week for the receiver.  If the current calendar is Gregorian, Sunday = 1, Monday = 2, etc.
 
 @author DJS 2013-02.
*/

- (NSInteger)dejal_weekday;
{
    return [self dejal_components:NSCalendarUnitWeekday].weekday;
}

/**
 Returns the day of the year for the receiver.  Note that this is different from the day of month.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_dayOfYear;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger dayOfYear = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    
    return dayOfYear;
}

/**
 Returns the day of the receiver.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_day;
{
    return [self dejal_components:NSCalendarUnitDay].day;
}

/**
 Returns the month of the receiver.
 
 @author DJS 2014-08.
 */

- (NSInteger)dejal_month;
{
    return [self dejal_components:NSCalendarUnitMonth].month;
}

/**
 Returns the year of the receiver.
 
 @author DJS 2014-08.
*/

- (NSInteger)dejal_year;
{
    return [self dejal_components:NSCalendarUnitYear].year;
}

/**
 Returns the requested date components for the receiver.  See also the convenience methods like -weekday, above.
 
 @param unitFlags An ORed set of date component flags, e.g. NSCalendarUnitDay.
 @returns Date components for the specified units.
 
 @author DJS 2014-08.
 */

- (NSDateComponents *)dejal_components:(NSCalendarUnit)unitFlags;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar components:unitFlags fromDate:self];
}

/**
 Given a time in a NSDate, returns the receiver with the time from that instead of the receiver's.  Useful if the receiver date doesn't include the time, and the time doesn't include the date.
 
 @author DJS 2012-02.
*/

- (NSDate *)dejal_dateWithTime:(NSDate *)time;
{
    NSDate *onlyDate = [self dejal_dateAsDateWithoutTime];
    NSDate *timeBase = [time dejal_dateAsDateWithoutTime];
    NSTimeInterval interval = [time timeIntervalSinceDate:timeBase];
    
    return [onlyDate dateByAddingTimeInterval:interval];
}

/**
 Returns the receiver aligned to the nearest minute increment.  For example passing 15 to a date with a time of 15:03 will align the time to 15:00, or 09:40 will align to 09:45.
 
 @param minuteIncrement The number of minutes to use to align the time, e.g. 5 or 15.
 @returns The aligned date.
 
 @author DJS 2014-04.
 */

- (NSDate *)dejal_dateByAligningToMinuteIncrement:(NSInteger)minuteIncrement;
{
    NSInteger incrementSeconds = minuteIncrement * 60;
    NSInteger referenceSeconds = [self timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceSeconds % incrementSeconds;
    NSInteger roundedToMinuteIncrement = referenceSeconds - remainingSeconds;
    
    if (remainingSeconds > incrementSeconds / 2)
    {
        roundedToMinuteIncrement = referenceSeconds + (incrementSeconds - remainingSeconds);
    }
    
    return [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)roundedToMinuteIncrement];
}

/**
 Returns the receiver with the specified number of minutes added.
 
 @author DJS 2014-04.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSDate *)dejal_dateByAddingMinutes:(NSInteger)numMinutes;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setMinute:numMinutes];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the receiver with the specified number of hours added.
 
 @author DJS 2011-10.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSDate *)dejal_dateByAddingHours:(NSInteger)numHours;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setHour:numHours];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the receiver with the specified number of days added.
 
 @author JLM 2009-07.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSDate *)dejal_dateByAddingDays:(NSInteger)numDays;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setDay:numDays];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the receiver with the specified number of weeks added.
 
 @author DJS 2012-01.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSDate *)dejal_dateByAddingWeeks:(NSInteger)numWeeks;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setWeekOfYear:numWeeks];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the receiver with the specified number of months added.
 
 @author DJS 2014-05.
*/

- (NSDate *)dejal_dateByAddingMonths:(NSInteger)numMonths;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setMonth:numMonths];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the receiver with the specified number of years added.
 
 @author DJS 2014-05.
*/

- (NSDate *)dejal_dateByAddingYears:(NSInteger)numYears;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:numYears];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    
    return date;
}

/**
 Returns the number of minutes between the receiver and the specified date.
 
 @author DJS 2012-11.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInMinutesTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitMinute fromDate:self toDate:toDate options:0];
    NSInteger minutes = [components minute];
    
    return minutes;
}

/**
 Returns the number of hours between the receiver and the specified date.
 
 @author DJS 2011-10.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInHoursTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitHour fromDate:self toDate:toDate options:0];
    NSInteger hours = [components hour];
    
    return hours;
}

/**
 Returns the number of days between the receiver and the specified date.
 
 @author DJS 2009-07.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInDaysTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self toDate:toDate options:0];
    NSInteger days = [components day];
    
    return days;
}

/**
 Returns the number of weeks between the receiver and the specified date.
 
 @author DJS 2013-07.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInWeeksTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekOfYear fromDate:self toDate:toDate options:0];
    NSInteger weeks = [components weekOfYear];
    
    return weeks;
}

/**
 Returns the number of months between the receiver and the specified date.
 
 @author DJS 2013-01.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInMonthsTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self toDate:toDate options:0];
    NSInteger months = [components month];
    
    return months;
}

/**
 Returns the number of years between the receiver and the specified date.
 
 @author DJS 2013-01.
 @version DJS 2014-05: changed to use the dejal_gregorianCalendar singleton.
*/

- (NSInteger)dejal_differenceInYearsTo:(NSDate *)toDate;
{
    NSCalendar *gregorian = [self dejal_gregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self toDate:toDate options:0];
    NSInteger years = [components year];
    
    return years;
}

/**
 Returns the receiver as a string in short format.
 
 @author DJS 2011-01.
*/

- (NSString *)dejal_formattedShortDateString;
{
    return [self dejal_formattedStringUsingDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

/**
 Returns the receiver as a string in long format.
 
 @author DJS 2009-07.
*/

- (NSString *)dejal_formattedDateString;
{
    return [self dejal_formattedStringUsingDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

/**
 Returns the receiver as a string with the specified date and time styles.
 
 @author DJS 2009-07.
 @version DJS 2014-08: changed to call -formattedStringUsingDateStyle:timeStyle:allowRelative:.
*/

- (NSString *)dejal_formattedStringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
{
    return [self dejal_formattedStringUsingDateStyle:dateStyle timeStyle:timeStyle allowRelative:NO];
}

/**
 Returns the receiver as a string with the specified date and time styles, optionally using a relative date (e.g. "yesterday").
 
 @param dateStyle The date style to use.
 @param timeStyle The time style to use.
 @param allowRelative YES to use a relative representation (e.g. "tomorrow"), or NO to always use absolute date.
 @returns A string representation of the receiver.
 
 @author DJS 2014-08.
 */

- (NSString *)dejal_formattedStringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle allowRelative:(BOOL)allowRelative;
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    formatter.doesRelativeDateFormatting = allowRelative;
    
    return [formatter stringFromDate:self];
}

/**
 Returns the receiver as a string with a relative time, e.g. "5 minutes", and optionally a suffix, e.g. "9 months ago".  If the receiver is the distant past or future, it uses the default value.
 
 @param unitsStyle The date components formatter style, e.g. NSDateComponentsFormatterUnitsStyleShort.
 @param maximumUnits The number of units to include, e.g. 1 for "5 minutes", 2 for "5 minutes, 13 seconds".
 @param keepZero If YES, the smallest unit is allowed to display zero (e.g. "3 mins, 0 secs"; if NO, it drops the zero (e.g. just "3 mins").
 @param defaultValue A string to output if the interval is in the distant past or future.
 @returns A relative string representation of the receiver.
 
 @author DJS 2014-08.
 @version DJS 2014-11: changed to use the class method.
 @version DJS 2015-01: removed the suffix parameter, since it caused localization issues.
 */

- (NSString *)dejal_relativeStringWithStyle:(NSDateComponentsFormatterUnitsStyle)unitsStyle maximumUnits:(NSInteger)maximumUnits keepZero:(BOOL)keepZero defaultValue:(NSString *)defaultValue;
{
    NSTimeInterval timeInterval = abs([self timeIntervalSinceNow]);
    
    return [[self class] dejal_relativeStringForTimeInterval:timeInterval style:unitsStyle maximumUnits:maximumUnits keepZero:keepZero defaultValue:defaultValue];
}

/**
 Returns the receiver as a string with a relative time, e.g. "5 minutes", and optionally a suffix, e.g. "9 months ago".  If the receiver is the distant past or future, it uses the default value.
 
 @param timeInterval The number of seconds for the relative time.
 @param unitsStyle The date components formatter style, e.g. NSDateComponentsFormatterUnitsStyleShort.
 @param maximumUnits The number of units to include, e.g. 1 for "5 minutes", 2 for "5 minutes, 13 seconds".
 @param keepZero If YES, the smallest unit is allowed to display zero (e.g. "3 mins, 0 secs"; if NO, it drops the zero (e.g. just "3 mins").
 @param defaultValue A string to output if the interval is in the distant past or future.
 @returns A relative string representation of the receiver.
 
 @author DJS 2014-08.
 @version DJS 2014-11: changed to use NSDateComponentsFormatter (requires OS X 10.10 or iOS 8 or later).
 @version DJS 2014-12: changed to use a localized string, so French can reorder the values.
 @version DJS 2015-01: removed the suffix parameter, since it caused localization issues.
 */

+ (NSString *)dejal_relativeStringForTimeInterval:(NSTimeInterval)timeInterval style:(NSDateComponentsFormatterUnitsStyle)unitsStyle maximumUnits:(NSInteger)maximumUnits keepZero:(BOOL)keepZero defaultValue:(NSString *)defaultValue;
{
    // If more than 10 years, assume distant past or future:
    if (abs(timeInterval) > 60 * 60 * 24 * 365 * 10)
    {
        return defaultValue;
    }
    
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    
    formatter.unitsStyle = unitsStyle;
    formatter.maximumUnitCount = maximumUnits;
    
    if (keepZero)
    {
        formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropLeading | NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle;
    }
    else
    {
        formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;
    }
    
    return [formatter stringFromTimeInterval:timeInterval];
}

/**
 Returns the date of the start of the month from the receiver, offset by the specified amount.  For example -3 for three months ago, oe 6 for in six months time.
 
 @author a commenter on Jeff's post, 2009-07.
 @version DJS 2014-05: changed to make an instance method instead of class method.
*/

- (NSDate *)dejal_dateOfMonthStartWithOffset:(NSInteger)monthOffset;
{
    NSDate *beginningOfMonth = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&beginningOfMonth interval:NULL forDate:self];
    NSDateComponents *month = [NSDateComponents new];
    [month setMonth:monthOffset];
    NSDate *monthStartDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:month toDate:beginningOfMonth options:0];
    
    return monthStartDateWithOffset;
}

/**
 Returns the date of the end of the month from the receiver, offset by the specified amount.
 
 @author a commenter on Jeff's post, 2009-07.
 @version DJS 2014-05: changed to make an instance method instead of class method.
*/

- (NSDate *)dejal_dateOfMonthEndWithOffset:(NSInteger)monthOffset;
{
    NSDate *beginningOfMonth = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&beginningOfMonth interval:NULL forDate:self];
    
    // Add 1 month + offset in months to the beginning of the current month:
    NSDateComponents *oneMonth = [NSDateComponents new];
    [oneMonth setMonth:(1 + monthOffset)];
    NSDate *beginningOfNextMonthWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:oneMonth toDate:beginningOfMonth options:0];
    
    // Subtract 1 second from the beginning next month with offset to get the end of the month with offset:
    NSDateComponents *negativeOneSecond = [NSDateComponents new];
    [negativeOneSecond setSecond:-1]; 
    NSDate *monthEndDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:negativeOneSecond toDate:beginningOfNextMonthWithOffset options:0];
    
    return monthEndDateWithOffset;
}

// Note: see also -formattedStringUsingDateStyle:timeStyle:, equivalent to a -descriptionWithDateFormat:timeFormat: method.

/**
 Returns the receiver expressed as a string using the user's preferred short date and time formats.  This method is compatible both with NSDate and NSCalendarDate.
 
 @author DJS 2003-11.
 @version DJS 2007-10: changed to avoid deprecated NSShortDateFormatString etc.
*/

- (NSString *)dejal_descriptionWithShortDateTime;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:self];
}

/**
 Returns the receiver expressed as a string using the user's preferred short date format.  This method is compatible both with NSDate and NSCalendarDate.
 
 @author DJS 2003-11.
 @version DJS 2007-10: changed to avoid deprecated NSShortDateFormatString etc.
*/

- (NSString *)dejal_descriptionWithShortDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:self];
}

/**
 Returns the receiver expressed as a string using the user's preferred short time format.  This method is compatible both with NSDate and NSCalendarDate.
 
 @author DJS 2003-11.
 @version DJS 2007-10: changed to avoid deprecated NSShortDateFormatString etc.
*/

- (NSString *)dejal_descriptionWithTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:self];
}

@end

