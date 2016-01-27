# KWLog


## 起源

最近想去优化一下以前的 KWListView 这个项目，或者说是觉得那套代码有很多很多不完善的地方，我需要重新编写一套逻辑。那在调试的过程中，就会出现很多BUG，而有的时候打印的多了，打印的结果就看起来很乱。在这种情况下，我需要一种东西去优化打印的结果以及获取更多的信息。（DDLog || XcodeColors 比 KWLog 强大，只是我觉得 KWLog 更轻量级）

<!--more-->

## 功能

KWLog 的功能相对简单一下，可以分级打印日志，在区分一下打印的时候还是会有些帮助。提供了一些辅助打印信息，通过这些打印我们可以轻松定位到打印位置所在的文件、方法、行数等一些信息，一定程度上提高开发效率。

如果你需要输出一些历史日志，那 KWLog 可能会对你有一些帮助，KWLog 会记录前面的日志信息，更提供了一种筛选机制，对所有的在册记录过滤筛选。

## 使用

### 导入工程

直接下载，导入到工程中。

目前不提供 cocospods 的方式导入到工程中，或者在以后也不会提供这样的方式，因为我觉得没有必要为这样的小得不能再小的库生成 pod 方式。

### 结构说明

![](http://www.makaiwen.com/cus_img/kwlog_1.png)

### 使用方法

#### 普通使用

最简单的使用莫过于同系统的 NSlog() 一样，KWLog 也的确提供了这样简单的方法，但是在这样使用之前，我们需要对一些默认设置进行一些修改。

```
KWDefaultLevel(KWLogLevelError);
```

通过上面的代码，我们去重新定义一下，我们需要打印日志的级别。目前分为4级，分别是不打印、普通打印、警告级打印、错误级打印，默认为不开启打印功能。

```
KWDefaultOption(KWLogOptionLine | KWLogOptionFunc | KWLogOptionFile | KWLogOptionThread);
```

上面的代码是用来设置默认的打印选项，可以设定多个选项，默认不添加任何打印选项。

那么根据上面修改的默认设定，我们就可以直接使用 KWLog() 打印日志，另外对于有一些地方需要特殊处理的，可以使用自定义化程度高一些的函数。

```
// 同时配置级别和打印选项
KWLogWithLevelAndOption(Level,Option,format,args...) 
// 可以配置打印选项
KWLogWithOption(Option,format,args...)
// 可以配置打印级别
KWLogWithLevel(Level,format,args...)
```

打印效果，如下

```
2016-01-26 17:03:02.007 KWLogDemo[92492:2695591] ❤️❤️❤️
line : 60
file : ViewController.m
func : -[ViewController btnClickAction:]
thread : {number = 1, name = main}
info : this a log info 2016-01-26 09:03:02 +0000
================== end ===================
```
#### 历史日志

历史日志输出在某种程度上会提高我们的开发效率，使用起来也很简单，可以直接在工程中调用，但是相对在工程中使用，我更倾向于在控制台使用。在断点情况下，利用我们经常使用的 ‘po’ 命令，如下：

```
po KWLogHistoryWithObject(self)
```

这里面的 self 是一个参数，我们可以通过参数去获取符合条件的日志，参数可以是字符串，也可以是其他类型，如果是字符串，就检测文件名或者调试打印自定义内容中包含字符串的日志，如果不是字符串，我们会默认你要输出与该类相关的日志。

打印效果，如下：
、、、
2016-01-26 17:07:46.504 KWLogDemo[92492:2695591] 
2016-01-25 14:41:57 +0000  ViewController.m  -[ViewController btnClickAction:]  60th  {number = 1, name = main}  this a log info 2016-01-25 14:41:57 +0000
2016-01-25 14:41:58 +0000  ViewController.m  -[ViewController btnClickAction:]  72th  {number = 1, name = main}  another a log info 2016-01-25 14:41:58 +0000
2016-01-25 14:41:59 +0000  ViewController.m  -[ViewController btnClickAction:]  75th  {number = 1, name = main}  another a log info 2016-01-25 14:41:59 +0000
2016-01-25 14:42:01 +0000  ViewController.m  -[ViewController btnClickAction:]  69th  {number = 1, name = main}  another a log info 2016-01-25 14:42:01 +0000
2016-01-26 09:02:45 +0000  ViewController.m  -[ViewController btnClickAction:]  75th  {number = 1, name = main}  another a log info 2016-01-26 09:02:45 +0000
2016-01-26 09:03:02 +0000  ViewController.m  -[ViewController btnClickAction:]  60th  {number = 1, name = main}  this a log info 2016-01-26 09:03:02 +0000
、、、

保存大量的历史日志会拖累工程的运行效率，相对应地我们需要在使用一段时候，或者是有需要的时候清空这些历史日志。

```
KWLogHistoryClear()
```
KWLog 还有很多需要完善的地方，希望大家可以多提意见，在此先行谢过~

## 联系

博客：[Kevin](http://www.makaiwen.com/) 
