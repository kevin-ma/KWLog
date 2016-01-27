//
//  KWLogInfo.m
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/26.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWLogInfo.h"

NSString *const KWLevelKey      = @"level";
NSString *const KWOptionKey     = @"option";
NSString *const KWDateKey       = @"date";
NSString *const KWLineKey       = @"line";
NSString *const KWThreadKey     = @"thread";
NSString *const KWPathKey       = @"path";
NSString *const KWFunctionKey   = @"function";
NSString *const KWDataKey       = @"data";

@implementation KWLogInfo

- (NSString *)description
{
    if (self == [KWLogInfo instance]) {
        NSMutableString *logInfo;
        if (self.level == KWLogLevelNormal) {
            logInfo = [@"\n" mutableCopy];
        } else if (self.level == KWLogLevelError) {
            logInfo = [@"❤️❤️❤️\n" mutableCopy];
        } else if (self.level == KWLogLevelWarning) {
            logInfo = [@"💛💛💛\n" mutableCopy];
        } else {
            logInfo = [@"\n" mutableCopy];
        }
        
        if (self.option & KWLogOptionNone) {
            
        }
        if (self.option & KWLogOptionLine) {
            [logInfo appendFormat:@"line : %lu\n",(unsigned long)_line];
        }
        if (self.option & KWLogOptionFile) {
            [logInfo appendFormat:@"file : %@\n",_path];
        }
        if (self.option & KWLogOptionFunc) {
            [logInfo appendFormat:@"func : %@\n",_function];
        }
        
        if (self.option & KWLogOptionThread) {
            [logInfo appendFormat:@"thread : %@\n",_thread];
        }
        
        if (_data) {
            [logInfo appendFormat:@"info : %@\n",_data];
        }
        [logInfo appendString:@"================== end ==================="];

        return logInfo;
    }
    
    return [NSString stringWithFormat:@"%@  %@  %@  %luth  %@  %@\n",_date,_path,_function,(unsigned long)_line,_thread,_data];
}

+ (instancetype)instance
{
    static KWLogInfo *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[KWLogInfo alloc] init];
    });
    return _instance;
}

+ (instancetype)logInfoWithLevel:(KWLogLevel)level
                          option:(KWLogOption)option
                            date:(NSDate *)date
                            line:(int)line
                          thread:(NSString *)thread
                            path:(NSString *)path
                        function:(NSString *)func
                            data:(NSString *)data
{
    KWLogInfo *info = [self instance];
    info.level = level;
    info.option = option;
    info.date = date;
    info.line = (NSUInteger)line;
    info.thread = thread;
    info.path = path;
    info.function = func;
    info.data = data;
    return info;
}

+ (instancetype)logInfoWithDict:(NSDictionary *)dict
{
    KWLogInfo *logInfo = [[KWLogInfo alloc] init];
    logInfo.level = (KWLogLevel)[dict[KWLevelKey] integerValue];
    logInfo.option = (KWLogOption)[dict[KWOptionKey] integerValue];
    logInfo.date = dict[KWDateKey];
    logInfo.line = [dict[KWLineKey] integerValue];
    logInfo.thread = dict[KWThreadKey];
    logInfo.path = dict[KWPathKey];
    logInfo.function = dict[KWFunctionKey];
    logInfo.data = dict[KWDataKey];
    return logInfo;
}

+ (NSArray *)logInfosWithDicts:(NSArray *)dicts
{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in dicts) {
        [array addObject:[self logInfoWithDict:dict]];
    }
    return [array copy];
}

- (NSDictionary *)dictValue
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    dict[KWLevelKey] = @(self.level);
    dict[KWOptionKey] = @(self.option);
    dict[KWDataKey] = self.data;
    dict[KWLineKey] = @(self.line);
    dict[KWThreadKey] = self.thread;
    dict[KWPathKey] = self.path;
    dict[KWFunctionKey] = self.function;
    dict[KWDateKey] = self.date;
    return [dict copy];
}
@end
