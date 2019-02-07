//
//  NSDate+YZBim.h
//  BIM
//
//  Created by Dion Chen on 15/5/22.
//  Copyright (c) 2015年 Pu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Easy)

- (NSString *)format;
- (NSString *)formatToISOString;
- (NSString *)formatWithoutSec;
- (NSString *)formatOnlyDay;
- (NSString *)formatOnlyTime;
- (NSString *)formatMonthAndDay;
- (float)calculateDays;
- (BOOL)equalWith:(NSDate *)date;

+ (NSDate *)dateFromISOString:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFormDayString:(NSString *)dateString;

/**智能时间[eg. : 今天xx:xx:xx|昨天xx:xx:xx]*/
- (NSString *)formatIntellectualTime;

#pragma mark -
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;

- (BOOL)isInFuture;
- (BOOL)isInPast;

- (NSDate *)dateAtStartOfDay;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;

@end
