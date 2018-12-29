//
//  iOS组件化调研VC.m
//  note
//
//  Created by liuyujia on 2018/12/29.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "iOS组件化调研VC.h"

@interface iOS_____VC ()

@end

@implementation iOS_____VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - 组件化
/**
 组件化方案调研
 
 一、什么是组件化
 从工程代码层面来说，组件化的实施通常是通过
 1.中间件解决组件间头文件直接引用、依赖混乱的问题；
 2.从实际开发来说，组件之间最大的需求就是页面跳转，需要从组件A的pageA页面跳转到组件B的pageB页面，避免对组件B页面ViewController头文件的直接依赖。
 
 二、为什么要组件化？
 1.组件化解决的问题
 问题1.每个模块都离不开其他模块，互相依赖粘在一起成为一坨：耦合比较严重（因为没有明确的约束，「组件」间引用的现象会比较多）
 问题2，多人同时开发时，容易出现冲突（尤其是Xcode Project文件）
 问题3，业务方的开发效率不够高（只关心自己的组件，却要编译整个项目，与其他不相干的代码糅合在一起）
 2.组件化的好处
 一般意义：
 
 加快编译速度（不用编译主客那一大坨代码了）；
 各组件自由选择开发姿势（MVC / MVVM / FRP）；
 组件工程本身可以独立开发测试，方便 QA 有针对性地测试；
 规范组件之间的通信接，让各个组件对外都提供一个黑盒服务，减少沟通和维护成本，提高效率；
 
 对于公司已有项目的现实意义：
 
 业务分层、解耦，使代码变得可维护；
 有效的拆分、组织日益庞大的工程代码，使工程目录变得可维护；
 便于各业务功能拆分、抽离，实现真正的功能复用；
 业务隔离，跨团队开发代码控制和版本风险控制的实现；
 模块化对代码的封装性、合理性都有一定的要求，提升开发同学的设计能力；
 在维护好各级组件的情况下，随意组合满足不同客户需求；（只需要将之前的多个业务组件模块在新的主App中进行组装即可快速迭代出下一个全新App）
 
 3.什么情况下进行组件化比较合适？
 当项目迭代到一定时期之后，便会出现一些相对独立的业务功能模块，而团队的规模也会随着项目迭代逐渐增长，这便是中小型应用考虑组件化的时机了。这时为了更好的分工协作，团队安排团队成员各自维护一个相对独立的业务组件是比较常见的做法。
 在这时这个时候来引入组件化方案，是比较合适的时机。长远来看，组件化带来的好处是远远大于坏处的，特别是随着项目的规模增大，这种好处会变得越来越明显
 
 三、如何组件化？
 1.基础模块拆分：网络请求、数据存储模块、性能统计；对于基础模块来说，其本身应该是自洽的，即可以单独编译或者几个模块合在一起可以单独编译。所有的依赖关系都应该是业务模块指向基础模块的。
 基础模块之间尽量避免产生横向依赖。
 2.业务模块拆分：
 对业务量很大的工程来说，我个人更加推荐“业务-分层”这样的结构，而不是“分层-业务”，即类似下面的 group 结构：
 - BusinessA
     - Model
     - View
     - Controller
     - Store
 - BusinessB
     - Model
     - View
     - Controller
     -Store
 3.组件化技术的难点？
 3.1、组件的拆分方式问题：
 可以利用CocoaPods配合git做代码版本管理，独立业务模块单独成库。
 但这仅仅是物理上拆分了，拆分后的代码编译是肯定通不过的，因为如下：
 会找不到依赖的其它各个模块的头文件而报错。
 
 这里引出的又是另一个问题：
 3.2、组件化如何解耦？
 组件间解耦，是组件化必须解决的一个问题。
 换句话说，就是如何解除业务模块间的横向依赖。
 还是拿上边举得例子来说：
 按软件工程的思路，下意识就会加一个中间层Mediator：
 这样一来，各个模块直接都不需要再互相依赖，而是仅需要依赖 Mediator 层即可。
 可直观上看，这样做并没有什么好处，依赖关系并没有解除，Mediator 依赖了所有模块，而调用者又依赖 Mediator，最后还是一坨互相依赖，跟原来没有 Mediator 的方案相比除了更麻烦点其他没区别。
 
 3.3、对此，可以参考业内的流行方案：
 *基于URL Router、ModuleManager
 代表：蘑菇街 Limboy
 *基于Target-Action、Runtime、Category
 代表：安居客 casa
 【后续继续讨论】
 
 四、其他
 开发流程控制
 托管平台选择：Gitlab
 
 
 ------------------------------------------------------
 作者：yehot
 链接：https://www.jianshu.com/p/34f23b694412
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
