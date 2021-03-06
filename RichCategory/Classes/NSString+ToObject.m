//
//  NSString+ToObject.m
//  Pods
//
//  Created by 张帆 on 17/3/14.
//
//

#ifdef DEBUG
#define GDLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define GDLog(format, ...)
#endif

#import "NSString+ToObject.h"

@implementation NSString (ToObject)

- (NSDictionary *)toNSDictionary {
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || ![result isKindOfClass:[NSDictionary class]]){
        GDLog(@"string-->dictionary faild, err = %@", err);
        return @{};
    }
    return result;
}

- (NSArray *)toNSArray {
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || ![result isKindOfClass:[NSArray class]]){
        GDLog(@"string-->array faild, err = %@", err);
        return @[];
    }
    return result;
}

- (BOOL)toBOOL {
    if ([self isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

@end
