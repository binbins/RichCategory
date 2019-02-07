//
//  NSDate+YZBim.m
//  BIM
//
//  Created by Dion Chen on 15/5/22.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import "NSDate+Easy.h"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_YEAR      31556926

#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (YZBim)

+ (NSDate*)dateFromISOString:(NSString*)dateString {
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)dateFormDayString:(NSString *)dateString
{
    if (!dateString || (NSNull *)dateString == [NSNull null]) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}

- (NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

- (NSString *)formatToISOString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [formatter stringFromDate:self];
}

- (NSString *)formatWithoutSec
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:self];
}

- (NSString *)formatOnlyDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:self];
}

- (NSString *)formatOnlyTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:self];
}

- (NSString *)formatMonthAndDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    return [formatter stringFromDate:self];
}

- (BOOL)equalWith:(NSDate *)date
{
    return ([self compare:date] == NSOrderedSame);
}

- (float)calculateDays
{
    NSTimeInterval before = [self timeIntervalSince1970] * 1;
    NSDate * localDate = [NSDate date];
    NSTimeInterval now = [localDate timeIntervalSince1970] * 1;
    NSTimeInterval seconds = now - before;
    NSInteger days = seconds / 24 / 60 / 60.0;
    return days;
}

#pragma mark ----

/**智能时间[eg. : 今天xx:xx:xx|昨天xx:xx:xx]*/
- (NSString *)formatIntellectualTime
{
    if ([self isToday]) {
        return [NSString stringWithFormat:@"今天 %@", [self formatOnlyTime]];
    } else if ([self isYesterday]) {
        return [NSString stringWithFormat:@"昨天 %@", [self formatOnlyTime]];
    } else if ([self isEqualToDateIgnoringTime:[NSDate dateWithDaysBeforeNow:2]]) {
        return [NSString stringWithFormat:@"前天 %@", [self formatOnlyTime]];
    } else {
        if ([self isEqualToDateOfYear:[NSDate date]]) {
            return [self formatCustomWithoutYear];
        }
        return [self formatCustom];
        //        return [self formatOnlyDay];
    }
}

#pragma mark -

- (NSString *)formatCustom
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSDate currentLocale]];
    
    NSString *dateString = [NSDate isChineseLanguage]?@"yyyy-MM-dd":([NSDate isUSLocale]?@"MMM dd, yyyy":@"dd MMM yyyy");
    NSString *timeString = @"HH:mm";
    formatter.dateFormat = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    return [formatter stringFromDate:self];
}

- (NSString *)formatCustomWithoutYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSDate currentLocale]];
    
    NSString *dateString = [NSDate isChineseLanguage]?@"MM-dd":([NSDate isUSLocale]?@"MMM dd":@"dd MMM");
    NSString *timeString = @"HH:mm";
    formatter.dateFormat = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    return [formatter stringFromDate:self];
}

/** 语言 */
+ (NSLocale *)currentLocale
{
    if ([self isChineseLanguage]) {
        return [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    } else {
        return [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    }
}

+ (BOOL)isChineseLanguage
{
    return YES;
}

+ (BOOL)isUSLocale
{
    return YES;
}

#pragma mark - ================ YZDate ===============
#pragma mark Relative Dates
#pragma mark Comparing Dates

+ (NSInteger)daysOfMonth:(NSInteger)month ofYear:(NSInteger)year
{
    NSInteger days;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            days = 30;
            break;
        case 2:{
            if((year % 4==0 && year % 100!=0) || year % 400==0)
                days = 29;
            else
                days = 28;
            break;
        }
        default:
            days = 30;
            break;
    }
    return days;
}

+ (NSDate *)tomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)yesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

- (NSDate *)monthsAgo:(NSInteger)months
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:-months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return newDate;
}

- (NSDate *)monthsLater:(NSInteger)months
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return newDate;
}

- (NSDate *)daysAgo:(NSInteger)days
{
    return [self dateBySubtractingDays:days];
}

- (NSDate *)daysLater:(NSInteger)days
{
    return [self dateByAddingDays:days];
}

- (NSDate *)hoursAgo:(NSInteger)hours
{
    return [self dateBySubtractingHours:hours];
}

- (NSDate *)hoursLater:(NSInteger)hours
{
    return [self dateByAddingHours:hours];
}

- (NSDate *)minutesAgo:(NSInteger)minutes
{
    return [self dateBySubtractingMinutes:minutes];
}

- (NSDate *)minutesLater:(NSInteger)minutes
{
    return [self dateByAddingMinutes:minutes];
}

+ (NSDate *)dateWithTimeIntervalString:(NSString *)string
{
    return [NSDate dateWithTimeIntervalSince1970:[string longLongValue] / 1000.0];
}

+ (NSDate *)dateWithMonthsFromNow:(NSInteger)months
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    return newDate;
}

+ (NSDate *)dateWithMonthsBeforeNow:(NSInteger)months
{
    return [NSDate dateWithMonthsFromNow:-months];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days
{
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days
{
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [NSDate dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *systemTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setTimeZone:systemTimeZone];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:second];
    return [dateComps date];
}

#pragma mark Comparing Dates

- (BOOL)isEqualToDateOfYear:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isEqualToDateOfMonth:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month));
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate tomorrow]];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate yesterday]];
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

- (BOOL)isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}

#pragma mark Adjusting Dates

- (NSDate *)dateByAddingDays:(NSInteger)dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays
{
    return [self dateByAddingDays:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours
{
    return [self dateByAddingHours:(dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes
{
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDate *)dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

@end
