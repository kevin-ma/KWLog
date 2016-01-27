//
//  KWLogHistoryHandler.h
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/26.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWLogInfo;

@interface KWLogHistoryHandle : NSObject

+ (instancetype)defaultHandle;

- (void)writeToHistory:(KWLogInfo *)info;

- (NSArray *)readFromHistoryWithStartDate:(NSDate *)date object:(id)object;

- (void)removeHistory;
@end
