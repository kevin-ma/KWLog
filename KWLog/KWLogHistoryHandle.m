//
//  KWLogHistoryHandler.m
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/26.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWLogHistoryHandle.h"
#import "KWLogInfo.h"

@interface KWLogHistoryHandle ()

@property (nonatomic, copy) NSString *historyPath;

@end

@implementation KWLogHistoryHandle

+(instancetype)defaultHandle
{
    static KWLogHistoryHandle *_handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [[KWLogHistoryHandle alloc] init];
    });
    return _handle;
}

- (void)writeToHistory:(KWLogInfo *)info
{
    NSMutableArray *temp = [[self readFromHistoryWithStartDate:nil object:nil] mutableCopy];
    [temp addObject:info.dictValue];
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

- (void)removeHistory
{
    [[NSFileManager defaultManager] removeItemAtPath:self.historyPath error:nil];
    self.historyPath = nil;
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
