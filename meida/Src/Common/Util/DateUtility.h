//
//  DateUtility.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//
#import "NSDate+LSExtension.h"

#define DAY_OF_SECONDS      24*60*60
#define SECONDS_IN_A_YEAR   365*DAY_OF_SECONDS

#define DEFAULT_DATE_TEMPLATE_STRING @"yyyyMMddHHmmss"
//#define DEFAULT_DATE_TEMPLATE_STRING @"HH:mm:ss dd/MM/yy"
#define SHORT_DATE_TEMPLATE_STRING   @"yyyy-MM-dd"
#define HOUR_MINUT_TEMPLATE_STRING   @"HH:mm"
#define YEAR_MONTH_TEMPLATE_STRING   @"yyyy-MM"

struct MNSDate {
    NSUInteger second;
    NSUInteger minute;
    NSUInteger hour;
    NSUInteger weekday;
    NSUInteger day;
    NSUInteger month;
    NSUInteger year;
};
typedef struct MNSDate MNSDate;

CG_INLINE MNSDate MNSDateMake(NSDate *date) {
    MNSDate MNSDate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    MNSDate.second = [components second];
    MNSDate.minute = [components minute];
    MNSDate.hour = [components hour];
    MNSDate.weekday = [components weekday];
    MNSDate.day = [components day];
    MNSDate.month = [components month];
    MNSDate.year = [components year];
    
    return MNSDate;
}

CG_INLINE NSArray *getWeekdaySymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *weekdaySymbols = [formatter weekdaySymbols];
    
    return weekdaySymbols;
}

CG_INLINE NSArray *getShortWeekdaySymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *weekdaySymbols = [formatter shortWeekdaySymbols];
    
    return weekdaySymbols;
}

CG_INLINE NSArray *getMonthSymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *monthSymbols = [formatter monthSymbols];
    
    return monthSymbols;
}

CG_INLINE NSArray *getShortMonthSymbols() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *monthSymbols = [formatter shortMonthSymbols];
    
    return monthSymbols;
}

CG_INLINE NSDate *getDate(NSDate *fromDate, NSInteger dayGap) {
    return [NSDate dateWithTimeInterval:DAY_OF_SECONDS * dayGap sinceDate:fromDate];
}

CG_INLINE NSDate *getLocalDateFromGMTDate(NSDate *GMTDate) {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: GMTDate];
    
    NSDate *localeDate = [GMTDate  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

CG_INLINE NSDate *getLastDateOfMonth(NSDate *targetMonthDay) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange daysRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:targetMonthDay];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:targetMonthDay];
    [components setDay:daysRange.length];
    
    return [calendar dateFromComponents:components];
}

CG_INLINE NSDate *getFirstDateOfMonth(NSDate *targetMonthDay) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:targetMonthDay];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

CG_INLINE NSDate *getFirstDateOfWeek(NSDate *date) {
    MNSDate MNSDate = MNSDateMake(date);
    
    return getDate(date, -1 * (MNSDate.weekday - 1));
}

CG_INLINE NSDate *getTomorrowDate() {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [calendar components:kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:today];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSTimeInterval timeInterval = DAY_OF_SECONDS - 3600 * hour - 60 * minute - second + 1;
    
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:today];;
}

CG_INLINE NSDate *getDateFromString(NSString *dateStringTemplate, NSString *dateStr) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    return date;
}

CG_INLINE NSDate *getShortDateFromString(NSString *dateStringTemplate, NSString *dateStr) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = SHORT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    return date;
}

CG_INLINE NSString *getStringFromDate(NSString *dateStringTemplate, NSDate *date) {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (!dateStringTemplate) {
        dateStringTemplate = DEFAULT_DATE_TEMPLATE_STRING;
    }
    
    [dateFormatter setDateFormat:dateStringTemplate];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

CG_INLINE NSString *getStringFromTimeInterval(NSTimeInterval timeInterval) {
    
    if (timeInterval <= 0) {
        return nil;
    }
    
    NSString *dateStr = nil;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *todayDate = [NSDate date];
    NSDate *yesterdayDate = [todayDate ls_dateBySubtractingDays:1];
    //NSDate *beforeYesterdayDate = [todayDate ls_dateBySubtractingDays:2];
    
    NSTimeInterval beforeYesterdayDateTI = [[yesterdayDate ls_dateByIgnoringTimeComponents] timeIntervalSince1970];
    
    NSString *dateStringTemplate = SHORT_DATE_TEMPLATE_STRING;
    // NSDateFormatter 的初始化很耗性能，这里使用static标记
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    //今天
    if ([date ls_isEqualToDateForDay:todayDate]) {
        dateStringTemplate = HOUR_MINUT_TEMPLATE_STRING;
        [dateFormatter setDateFormat:dateStringTemplate];
        dateStr = [dateFormatter stringFromDate:date];
    }
    //昨天
    else if ([date ls_isEqualToDateForDay:yesterdayDate]) {
        dateStringTemplate = HOUR_MINUT_TEMPLATE_STRING;
        [dateFormatter setDateFormat:dateStringTemplate];
        dateStr = [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
    }
    //更早
    else if (timeInterval < beforeYesterdayDateTI) {
        dateStringTemplate = @"yy/MM/dd";
        [dateFormatter setDateFormat:dateStringTemplate];
        dateStr = [dateFormatter stringFromDate:date];
    }
    
    return dateStr;
}

CG_INLINE NSInteger getWeekDayFromDate(NSDate *_date) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:_date];
    NSInteger week = [comps weekday];
    return week;
}

CG_INLINE NSString *getChinaWeekdayFromDate(NSDate *_date){
    int _weekday = (int)getWeekDayFromDate(_date);
    NSString *weekdayOfChina = @"";
    switch (_weekday) {
        case 1:
            weekdayOfChina = @"星期一";
            break;
        case 2:
            weekdayOfChina = @"星期二";
            break;
        case 3:
            weekdayOfChina = @"星期三";
            break;
        case 4:
            weekdayOfChina = @"星期四";
            break;
        case 5:
            weekdayOfChina = @"星期五";
            break;
        case 6:
            weekdayOfChina = @"星期六";
            break;
        case 7:
            weekdayOfChina = @"星期日";
            break;
            
        default:
            break;
    }
    return weekdayOfChina;
}

CG_INLINE NSString *getChineseCalendarWithDate(NSDate *date) {
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子",   @"乙丑",  @"丙寅",  @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑",  @"戊寅",  @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
//    NSLog(@"%ld_%ld_%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str = [NSString stringWithFormat: @"%@-%@-%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}

CG_INLINE NSDate *getDateAfterMonth(int _monthB ,NSDate *_date) {
    int _yearB = _monthB / 12;
    if (_yearB > 0) {
        _monthB = _monthB % 12;
    }
    
    int year = [getStringFromDate(@"yyyy", _date) intValue];
    int month = [getStringFromDate(@"MM", _date) intValue];
    
    month = month + _monthB;
    year = year + _yearB;
    
    if (month > 12) {
        year++;
        month -= 12;
    }
    NSString *resultDateStr = [NSString stringWithFormat:@"%d-%d-%@",year,month,getStringFromDate(@"dd HH:mm:ss", _date)];
    NSDate *resultDate = getDateFromString(@"yyyy-MM-dd HH:mm:ss", resultDateStr);

    return resultDate;
}


CG_INLINE NSDate *timestampToDate(NSTimeInterval timeInterval) {
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

CG_INLINE NSDate *javaTimestampToDate(NSString *timeInterval) {
    @try {
        NSString *temp = [timeInterval copy];
        if(temp && ![temp isEqualToString:@""]){
            if([temp length] == 10){
                temp = [NSString stringWithFormat:@"%@.000",temp];
            }else if([temp length] == 13){
                temp = [NSString stringWithFormat:@"%@.%@",[temp substringToIndex:10],[temp substringFromIndex:10]];
            }
            return [NSDate dateWithTimeIntervalSince1970:[temp doubleValue]];
        }
        return nil;
    }
    @catch (NSException *exception) {
        
    }
}

CG_INLINE NSString *dateToJavaTimestamp(NSDate *date) {
    if(!date){
        return @"";
    }
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return [[NSString stringWithFormat:@"%.3f",timeInterval] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

CG_INLINE NSString *stringToJavaTimestamp(NSString *templateStr,NSString *dateString) {
    NSDate *date = getDateFromString(templateStr, dateString);
    if(!date){
        return @"";
    }
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return [[NSString stringWithFormat:@"%.3f",timeInterval] stringByReplacingOccurrencesOfString:@"." withString:@""];
}

//获取当前时间到2000年的毫秒数
CG_INLINE NSString *getTimestampStringWithDate(NSDate *date) {
    if (!date) {
        return nil;
    }
    long long timeInterval = [date timeIntervalSinceReferenceDate];
    timeInterval = (timeInterval + SECONDS_IN_A_YEAR) * 1000;
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%lld", timeInterval];
    return timeIntervalStr;
}

//获取当天 00:00 点时间的毫秒数和 24:00 点的毫秒数
CG_INLINE NSDictionary *getMinTimestampAndMaxTimestampWithDate(NSDate *date) {
    if (!date) {
        return nil;
    }
    NSString *dateStr = getStringFromDate(@"yyyy-MM-dd", date);
    NSDate *dateCopy = getDateFromString(@"yyyy-MM-dd", dateStr);
    long long minTimestamp = [dateCopy timeIntervalSinceReferenceDate];
    minTimestamp = (minTimestamp + SECONDS_IN_A_YEAR) * 1000;
    NSString *minTimestampStr = [NSString stringWithFormat:@"%lld", minTimestamp];
    NSString *maxTimestampStr = [NSString stringWithFormat:@"%lld", minTimestamp+DAY_OF_SECONDS*1000];
    return @{@"minTimestampStr":minTimestampStr, @"maxTimestampStr":maxTimestampStr};
}

//中国农历节日
CG_INLINE NSString *getLunarHoliDayDate(NSDate *date) {
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    NSDictionary *chineseHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"除夕",  @"12-30",
                                    @"春节",  @"1-1",
                                    @"元宵节", @"1-15",
                                    @"端午节", @"5-5",
                                    @"七夕节", @"7-7",
                                    @"中元节", @"7-15",
                                    @"中秋节", @"8-15",
                                    @"重阳节", @"9-9",
                                    @"腊八节", @"12-8",
                                    @"小年",  @"12-24",
                                    nil];
    
    localeComp = [localeCalendar components:unitFlags fromDate:date];
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    NSString *key_str = [NSString stringWithFormat:@"%ld-%ld",localeComp.month,localeComp.day];
#else
    NSString *key_str = [NSString stringWithFormat:@"%d-%d",localeComp.month,localeComp.day];
#endif
//    NSString *key_str = [NSString stringWithFormat:@"%ld-%ld",localeComp.month,localeComp.day];
    NSArray *keyArray = [chineseHoliDay allKeys];
    NSString *holiday_str = nil;
    for (NSString *key in keyArray) {
        if ([key_str isEqualToString:key]) {
            holiday_str = [chineseHoliDay objectForKey:key_str];
            break;
        }
    }
    return holiday_str;
}

//中国阳历节日
CG_INLINE NSString *getGregorianHoliDayDate(NSDate *date) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *localeComp = [gregorian components:unitFlags fromDate:date];
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    NSString *monthAndDay = [NSString stringWithFormat:@"%ld-%ld", localeComp.month, localeComp.day];
#else
    NSString *monthAndDay = [NSString stringWithFormat:@"%d-%d", localeComp.month, localeComp.day];
#endif
//    NSString *monthAndDay = [NSString stringWithFormat:@"%ld-%ld", localeComp.month, localeComp.day];
    NSDictionary *gregorianHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"元旦节", @"1-1",
                                      @"妇女节", @"3-8",
                                      @"植树节", @"3-12",
                                      @"愚人节", @"4-1",
                                      @"劳动节", @"5-1",
                                      @"青年节", @"5-4",
                                      @"儿童节", @"6-1",
                                      @"建党节", @"7-1",
                                      @"建军节", @"8-1",
                                      @"教师节", @"9-10",
                                      @"国庆节", @"10-1",
                                      nil];
    NSArray *keyArray = [gregorianHoliDay allKeys];
    NSString *holiday_str = nil;
    for (NSString *key in keyArray) {
        if ([monthAndDay isEqualToString:key]) {
            holiday_str = [gregorianHoliDay objectForKey:monthAndDay];
            break;
        }
    }
    return holiday_str;
}




