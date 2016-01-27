//
//  KWLog.c
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/25.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWLog.h"
#import "KWLogInfo.h"
#import "KWLogHistoryHandle.h"

KWLogLevel _level = KWLogLevelNone;
KWLogOption _option = KWLogOptionNone;


void KWDefaultOption(KWLogOption option)
{
    _option = option;
}

void KWDefaultLevel(KWLogLevel level)
{
    _level = level;
}

void KWBaseLogWithLevelAndPath(KWLogLevel level,KWLogOption option,const char *file,int line,const char * func,NSString *data)
{
    if (level == KWLogLevelNone) return;
    NSString *path = [[NSString stringWithCString:file encoding:NSUTF8StringEncoding] lastPathComponent];
    NSString *thread = [[[[NSThread currentThread] description] componentsSeparatedByString:@">"] lastObject];
    KWLogInfo *info = [KWLogInfo logInfoWithLevel:level option:option date:[NSDate date] line:line thread:thread path:path function:[NSString stringWithUTF8String:func] data:data];
    NSLog(@"%@",info);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KWLogHistoryHandle defaultHandle] writeToHistory:info];
    });
}

void KWFuncLogWithLevelAndPath(KWLogLevel level,KWLogOption option,const char *file,int line,const char *func,NSString *format,...)
{
    NSString *data = nil;
    if (format) {
        va_list args;
        va_start(args, format);
        data = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    char *function = (char *)func;
    char *filePath = (char *)file;
    KWBaseLogWithLevelAndPath(level, option, filePath, line,function, data);
}

void KWFuncLogWithPath(KWLogOption option,const char * file,int line,const char *func,NSString *format,...)
{
    NSString *data = nil;
    if (format) {
        va_list args;
        va_start(args, format);
        data = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    KWBaseLogWithLevelAndPath(_level, option, file, line,func, data);
}

void KWFuncLogWithLevel(KWLogLevel level,const char *file,int line,const char *func,NSString *format,...)
{
    NSString *data = nil;
    if (format) {
        va_list args;
        va_start(args, format);
        data = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    KWBaseLogWithLevelAndPath(level, _option, file, line,func, data);
}

void KWFuncLog(const char *file,int line,const char *func,NSString *format,...)
{
    NSString *data = nil;
    if (format) {
        va_list args;
        va_start(args, format);
        data = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    KWBaseLogWithLevelAndPath(_level, _option, file, line,func, data);
}

#pragma mark - 历史记录

void KWLogHistoryWithObject(id object)
{
    NSMutableString *string = [@"\n" mutableCopy];
    NSArray *infos = [KWLogInfo logInfosWithDicts:[[KWLogHistoryHandle defaultHandle] readFromHistoryWithStartDate:[NSDate date] object:object]];
    
    NSString *value = nil;
    if ([object isKindOfClass:[NSString class]]) {
        value = object;
    } else {
        value = NSStringFromClass([object class]);
    }
    
    NSArray *newInfos = nil;
    if (value) {
        NSString *format = [NSString stringWithFormat:@"path CONTAINS '%@' OR data CONTAINS '%@'",value,value];
        NSPredicate *pred = [NSPredicate predicateWithFormat:format];
        newInfos = [infos filteredArrayUsingPredicate:pred];
    } else {
        newInfos = infos;
    }
    for (KWLogInfo *info in newInfos) {
        [string appendString:[info description]];
    }
    if (newInfos && newInfos.count) {
        NSLog(@"%@",string);
    } else {
        NSLog(@"%@",value ? @"没有满足条件历史数据~" : @"还没有历史数据");
    }
}

void KWLogHistoryClear()
{
    [[KWLogHistoryHandle defaultHandle] removeHistory];
    NSLog(@"已清空~");
}
