//
//  KWCrashHandler.m
//  KWLogDemo
//
//  Created by 凯文马 on 16/3/11.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWCrashHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#include <stdlib.h>

NSString * const KWCrashHandlerSignalExceptionName = @"KWCrashHandlerSignalExceptionName";
NSString * const KWCrashHandlerSignalKey = @"KWCrashHandlerSignalKey";
NSString * const KWCrashHandlerAddressesKey = @"KWCrashHandlerAddressesKey";

volatile int32_t KWCrashCount = 0;
const int32_t KWCrashMaximum = 10;

const NSInteger KWCrashHandlerSkipAddressCount = 4;
const NSInteger KWCrashHandlerReportAddressCount = 5;

@interface KWCrashHandler ()
@property (nonatomic, copy) NSString *historyPath;
@end

@implementation KWCrashHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = KWCrashHandlerSkipAddressCount;i < KWCrashHandlerSkipAddressCount + KWCrashHandlerReportAddressCount;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        dismissed = YES;
    }else if (anIndex==1) {
        NSLog(@"ssssssss");
    }
}

- (void)validateAndSaveCriticalApplicationData:(NSException *)exception
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    [self writeToHistory:[NSString stringWithFormat:@"%@:%@-%@",[formatter stringFromDate:[NSDate date]],[exception reason],[exception userInfo]]];
}

- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData:exception];
    
    UIAlertView *alert =
    [[UIAlertView alloc]
      initWithTitle:@"抱歉，程序出现了异常"
      message:[NSString stringWithFormat:@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"@"异常原因如下:\n%@\n%@",[exception reason],[[exception userInfo] objectForKey:KWCrashHandlerAddressesKey]] delegate:self cancelButtonTitle:@"退出"
      otherButtonTitles:@"继续", nil];
    
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:KWCrashHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:KWCrashHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    } 
} 

// 写入文件
- (void)writeToHistory:(NSString *)info
{
    NSMutableArray *temp = [[self readFromHistoryWithStartDate:nil object:nil] mutableCopy];
    [temp addObject:info];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.historyPath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temp];
    [handle writeData:data];
    [handle closeFile];
}

- (NSArray *)readFromHistoryWithStartDate:(NSDate *)date object:(id)object
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self.historyPath];
    NSData *data = [handle readDataToEndOfFile];
    [handle closeFile];
    if (data && data.length) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return @[];
    }
}

- (NSString *)historyPath
{
    if (!_historyPath) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dirName = @"KWLog_History";
        NSString *fileDirPath = [docPath stringByAppendingPathComponent:dirName];
        NSString *fileName = @"history.log";
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirPath]) {
            
            BOOL suc = [[NSFileManager defaultManager] createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (!suc) {
                _historyPath = nil;
                return _historyPath;
            }
        }
        NSString *filePath = [fileDirPath stringByAppendingPathComponent:fileName];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (!exist) {
            BOOL suc = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            if (suc) {
                _historyPath = filePath;
            } else {
                _historyPath = nil;
            }
        } else {
            _historyPath = filePath;
        }
    }
    return _historyPath;
}

@end

void handleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&KWCrashCount);
    if (exceptionCount > KWCrashMaximum)
    {
        return;
    }
    
    NSArray *callStack = [KWCrashHandler backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:KWCrashHandlerAddressesKey];
    
    [[[KWCrashHandler alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}

void signalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&KWCrashCount);
    if (exceptionCount > KWCrashMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:@(signal) forKey:KWCrashHandlerSignalKey];
    
    NSArray *callStack = [KWCrashHandler backtrace];
    [userInfo setObject:callStack forKey:KWCrashHandlerAddressesKey];
    
    [[[KWCrashHandler alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:KWCrashHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal] userInfo:[NSDictionary dictionaryWithObject:@(signal) forKey:KWCrashHandlerSignalKey]] waitUntilDone:YES];
}

void monitorCrash(void)
{
    NSSetUncaughtExceptionHandler(&handleException);
    signal(SIGABRT, signalHandler);
    signal(SIGILL, signalHandler);
    signal(SIGSEGV, signalHandler);
    signal(SIGFPE, signalHandler);
    signal(SIGBUS, signalHandler);
    signal(SIGPIPE, signalHandler);
}
