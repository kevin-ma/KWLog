//
//  KWLogInfo.h
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/26.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWLog.h"

@interface KWLogInfo : NSObject

@property (nonatomic, assign) KWLogLevel level;

@property (nonatomic, assign) KWLogOption option;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *data;

@property (nonatomic, assign) NSUInteger line;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *function;

@property (nonatomic, copy) NSString *thread;

+ (instancetype)logInfoWithLevel:(KWLogLevel)level
                          option:(KWLogOption)option
                            date:(NSDate *)date
                            line:(int)line
                          thread:(NSString *)thread
                            path:(NSString *)path
                        function:(NSString *)func
                            data:(NSString *)data;

+ (instancetype)logInfoWithDict:(NSDictionary *)dict;
+ (NSArray *)logInfosWithDicts:(NSArray *)dicts;

- (NSDictionary *)dictValue;

@end
