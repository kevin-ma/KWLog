//
//  KWLog.h
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/25.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*
 I was writing an demo of reload view, and I found that I need to log much info to debug something, I need a way to help me tag infos and output other info as default,so I start to do some demo.
 You may think this is sth. boring, it does not metter. If you like this or don't unlike this,please give me shome idea.
 */

/* 
 This is an enumeration for setting the level of the log information output.
 The default value is the KWLogLevelNone, you can choose one of them as the default setting or a single log action setting.
 */

typedef enum {
    KWLogLevelNone,     // default,Unlog information.
    KWLogLevelNormal,   // the normal mode of log.
    KWLogLevelError,    // something red means error or serious.
    KWLogLevelWarning,  // songthing yellow means warning you and take focus
} KWLogLevel;

/*
 This is the log options prepared for you to set info added.
 The default value is the KWLogOptionNone, you can choose one or more of them as the default setting or a single log action setting.like KWLogOptionFile or KWLogOptionFile | KWLogOptionLine.
 */

typedef enum {
    KWLogOptionNone,            // default,Unlog added information.
    KWLogOptionFile,            // file path of log site,relative path is better.
    KWLogOptionLine = 1 << 1,   // the line num of log site.
    KWLogOptionFunc = 1 << 2,   // the function info of log site.
    KWLogOptionThread = 1 < 3,  // if something wrong with UI, you may need this.
} KWLogOption;

/**
 *
 *  You may can't believe that this is the main function of this KW.
 *  This function has both KWLogLevel and KWLogOption
 *
 *  @param Level   KWLogLevel
 *  @param Option  KWLogOption
 *  @param format  format description
 *  @param args... args... description
 */
#define KWLogWithLevelAndOption(Level,Option,format,args...) KWFuncLogWithLevelAndPath(Level,Option,(__FILE__),(__LINE__),(__PRETTY_FUNCTION__),format,##args)

/**
 *
 *  Like upper one ,can set option,will use the default level.
 */
#define KWLogWithOption(Option,format,args...) KWFuncLogWithPath(Option,(__FILE__),(__LINE__),(__PRETTY_FUNCTION__),format,##args)

/**
 *
 *  Like upper one ,can set level,will use the default option.
 */
#define KWLogWithLevel(Level,format,args...) KWFuncLogWithLevel(Level,(__FILE__),(__LINE__),(__PRETTY_FUNCTION__),format,##args)

/**
 *
 *  Maybe this is the most popular one,because it likes NSLog(...),use default setting.
 */
#define KWLog(format,args...) KWFuncLog((__FILE__),(__LINE__),(__PRETTY_FUNCTION__),format,##args)

/**
 *
 *  This here for you to set default option.
 */
void KWDefaultOption(KWLogOption option);

/**
 *
 *  This here for you to set default level.
 */
void KWDefaultLevel(KWLogLevel level);

/**
 *
 *  If you need to analyse the diffrence between logs,you may need this.
 *  It can filter the datas by the object you provide.
 *  Object can be NSString object or others,like self.
 */
void KWLogHistoryWithObject(id object);

void KWLogHistoryClear();

//  KWLogHistoryWithObject() and KWLogHistoryClear(),you can use them by termal with 'po',like po KWLogHistoryWithObject(@"kevin") or KWLogHistoryClear().

// the functions following are useless functions,you can ignore them.

void KWFuncLogWithLevelAndPath(KWLogLevel level,KWLogOption option,const char *file,int line,const char* func,NSString *format,...);

void KWFuncLogWithPath(KWLogOption option,const char *file,int line,const char *func,NSString *format,...);

void KWFuncLogWithLevel(KWLogLevel level,const char *file,int line,const char *func,NSString *format,...);

void KWFuncLog(const char *file,int line,const char *func,NSString *format,...);

