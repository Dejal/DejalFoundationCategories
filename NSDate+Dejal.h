//
//  NSDate+Dejal.h
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Thu Apr 17 2003.
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


@interface NSDate (Dejal)

@property (nonatomic, readonly) BOOL dejal_includesTime;
@property (nonatomic, readonly) BOOL dejal_isToday;

@property (nonatomic, readonly) NSInteger dejal_second;
@property (nonatomic, readonly) NSInteger dejal_minute;
@property (nonatomic, readonly) NSInteger dejal_hour;
@property (nonatomic, readonly) NSInteger dejal_weekday;
@property (nonatomic, readonly) NSInteger dejal_dayOfYear;
@property (nonatomic, readonly) NSInteger dejal_day;
@property (nonatomic, readonly) NSInteger dejal_month;
@property (nonatomic, readonly) NSInteger dejal_year;

+ (NSCalendar *)dejal_gregorianCalendar;

+ (NSDate *)dejal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day localTimeZone:(BOOL)localTimeZone;
+ (NSDate *)dejal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second localTimeZone:(BOOL)localTimeZone;

+ (NSDate *)dejal_dateWithString:(NSString *)string;
+ (NSDate *)dejal_dateWithString:(NSString *)string format:(NSString *)format;

- (NSString *)dejal_stringWithFormat:(NSString *)format;

+ (NSDateFormatter *)dejal_internetDateFormatter;

+ (NSDate *)dejal_dateWithJSONString:(NSString *)jsonDate;
+ (NSDate *)dejal_dateWithJSONString:(NSString *)jsonDate allowPlaceholder:(BOOL)allowPlaceholder;
- (NSString *)dejal_JSONStringValue;
- (NSString *)dejal_oldStyleJSONStringValue;

+ (NSTimeInterval)dejal_localTimeOffset;

+ (NSDate *)dejal_dateWithoutTime;
- (NSDate *)dejal_dateAsDateWithoutTime;

- (NSDateComponents *)dejal_components:(NSCalendarUnit)unitFlags;

- (BOOL)dejal_isBetweenDaysBefore:(NSInteger)daysBefore daysAfter:(NSInteger)daysAfter;

- (NSDate *)dejal_dateWithTime:(NSDate *)time;

- (NSDate *)dejal_dateByAligningToMinuteIncrement:(NSInteger)minuteIncrement;

- (NSDate *)dejal_dateByAddingMinutes:(NSInteger)numMinutes;
- (NSDate *)dejal_dateByAddingHours:(NSInteger)numHours;
- (NSDate *)dejal_dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dejal_dateByAddingWeeks:(NSInteger)numWeeks;
- (NSDate *)dejal_dateByAddingMonths:(NSInteger)numMonths;
- (NSDate *)dejal_dateByAddingYears:(NSInteger)numYears;

- (NSInteger)dejal_differenceInMinutesTo:(NSDate *)toDate;
- (NSInteger)dejal_differenceInHoursTo:(NSDate *)toDate;
- (NSInteger)dejal_differenceInDaysTo:(NSDate *)toDate;
- (NSInteger)dejal_differenceInWeeksTo:(NSDate *)toDate;
- (NSInteger)dejal_differenceInMonthsTo:(NSDate *)toDate;
- (NSInteger)dejal_differenceInYearsTo:(NSDate *)toDate;

- (NSString *)dejal_formattedShortDateString;
- (NSString *)dejal_formattedDateString;
- (NSString *)dejal_formattedStringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)dejal_formattedStringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle allowRelative:(BOOL)allowRelative;

- (NSString *)dejal_relativeStringWithStyle:(NSDateComponentsFormatterUnitsStyle)unitsStyle maximumUnits:(NSInteger)maximumUnits keepZero:(BOOL)keepZero defaultValue:(NSString *)defaultValue;
+ (NSString *)dejal_relativeStringForTimeInterval:(NSTimeInterval)timeInterval style:(NSDateComponentsFormatterUnitsStyle)unitsStyle maximumUnits:(NSInteger)maximumUnits keepZero:(BOOL)keepZero defaultValue:(NSString *)defaultValue;

- (NSDate *)dejal_dateOfMonthStartWithOffset:(NSInteger)monthOffset;
- (NSDate *)dejal_dateOfMonthEndWithOffset:(NSInteger)monthOffset;

- (NSString *)dejal_descriptionWithShortDateTime;
- (NSString *)dejal_descriptionWithShortDate;
- (NSString *)dejal_descriptionWithTime;

@end

