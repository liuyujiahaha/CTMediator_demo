//
//  Target-Action实现组件解耦CTMediator使用.m
//  note
//
//  Created by liuyujia on 2018/12/29.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "Target-Action实现组件解耦CTMediator使用.h"

@interface Target_Action______CTMediator__ ()

@end

@implementation Target_Action______CTMediator__

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 CTMediator使用
 
 一、普通页面跳转用法
 1.如果 HomeViewController 里有 N 个这样的 button 事件，每个点击后的跳转都是不同的页面，那么则 HomeViewController 里，需要导入 N 个这样的 OneViewController.h;
 2.如果 HomeViewController 是一个可以移植到其它项目的业务模块，在拖出首页 HomeVC 相关的业务代码时，难道还要把 'HomeViewController.m' 导入的 N 个其它 XxxViewController.h 都一块拖到新项目中么？
 
 这点就是因为代码的耦合导致了首页 HomeVC 没法方便的移植。
 说这样没有问题，是因为普通情况下，我们并没有移植 HomeVC 到其它项目的需求。
 至于什么时候会有这样的问题，以及，这样的问题如果解决，在 iOS组件化方案调研 这篇中，已经做过简单的讨论，这篇主要是选取了我个人较偏向的 Target-Action 这套方案，简单讲一下实现方式。
 
 二、Target-Action实现页面跳转
 看了一下爱士多的云信的代码，里面对tableview和cell和代理的解耦：代理是写在另外一个地方的，而cell直接使用Class获取的。
 Class clazz = NSClassFromString(identity);
 cell = [[clazz alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
 
 【使用步骤】
 【NewsViewController】
 1.创建Target-Action；【注意：我觉得这一步是否可以去掉，直接在ViewController里面增加这个方法不就可了，但是可能w是为了解耦？】
 创建一个Target_News类，在这个文件里，我们主要生成NewsViewController实例并为其进行一些必要的赋值params。
 这个类需要直接#import "NewsViewController.h"
 2.创建CTMediator的Category。
 CTMediator+NewsActions。这个Category利用Runtime调用我们刚刚生成的Target_News。
 由于利用了Runtime，导致我们完全不用#import刚刚生成的Target_News即可执行里面的方法，所以这一步，两个类是完全解耦的。也即是说，我们在完全解耦的情况下获取到了我们需要的NewsViewController。
 3.最终使用
 由于在Target中，传递值得方式采用了去Model化得方式，导致我们在整个过程中也没有#import任何Model。所以，我们的每个类都与Model解耦。
 （去Model化，没有模型都是字典）
 #import "CTMediator+NewsActions.h"
 UIViewController *viewController = [[CTMediator sharedInstance] yt_mediator_newsViewControllerWithParams:@{@"newsID":@"123456"}];
 
 4.不足
 这里其实唯一的问题就是，Target_Action里不得不填入一些 Hard Code，就是对创建的VC的赋值语句。不过这也是为了达到最大限度的解耦和灵活度而做的权衡。
 //  1. kCTMediatorTarget_News字符串 是 Target_xxx.h 中的 xxx 部分
 NSString * const kCTMediatorTarget_News = @"News";
 
 //  2. kCTMediatorActionNativTo_NewsViewController 是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
 NSString * const kCTMediatorActionNativTo_NewsViewController = @"NativeToNewsViewController";
 
 
 
 
 
 
 
 
 
 
 ----------------------------------------------
 作者：yehot
 链接：https://www.jianshu.com/p/76132c91be47
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
