//
//  KWCrashHandler.h
//  KWLogDemo
//
//  Created by 凯文马 on 16/3/11.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWCrashHandler : NSObject
{
    BOOL dismissed;
}
void handleException(NSException *exception);

void signalHandler(int signal);

void monitorCrash(void);

@end
