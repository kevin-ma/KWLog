//
//  ViewController.m
//  KWLogDemo
//
//  Created by 凯文马 on 16/1/25.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "ViewController.h"
#import "KWLog.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL logType;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    KWDefaultLevel(KWLogLevelError);
    KWDefaultOption(KWLogOptionLine | KWLogOptionFunc | KWLogOptionFile | KWLogOptionThread);
    
    NSArray *titles = @[@"A",@"A",@"A",@"B",@"B",@"B",@"print",@"clear"];
    
    NSUInteger column = 2;
    CGFloat width = 100.f;
    CGFloat height = 44.f;
    CGFloat margin = (self.view.bounds.size.width - column * width) / column;
    CGFloat startX = margin * 0.5f;
    CGFloat startY= 50.f;
    
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [self createBtnWithTitle:titles[i]];
        CGFloat x = i % column * (margin + width) + startX;
        CGFloat y = i / column * (margin + height) + startY;
        btn.frame = CGRectMake(x, y, width, height);
        btn.tag = i;
        [self.view addSubview:btn];
    }
}

- (UIButton *)createBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)btnClickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            KWLog(@"this a log info %@",[NSDate date]);
            break;
        case 1:
            KWLogWithLevelAndOption(KWLogLevelNormal, KWLogOptionFile, @"this a log info %@",[NSDate date]);
            break;
        case 2:
            KWLogWithLevelAndOption(KWLogLevelWarning, KWLogOptionFunc, @"this a log info %@",[NSDate date]);
            break;
        case 3:
            KWLogWithLevelAndOption(KWLogLevelError, KWLogOptionLine, @"another a log info %@",[NSDate date]);
            break;
        case 4:
            KWLogWithLevelAndOption(KWLogLevelWarning, KWLogOptionNone, @"another a log info %@",[NSDate date]);
            break;
        case 5:
            KWLogWithLevelAndOption(KWLogLevelNormal, KWLogOptionThread, @"another a log info %@",[NSDate date]);
            break;
        case 6:
            KWLogHistoryWithObject(@"another");
            break;
        case 7:
            KWLogHistoryClear();
            break;
        default:
            break;
    }
}



@end
