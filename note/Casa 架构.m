//
//  Casa 架构.m
//  note
//
//  Created by liuyujia on 2018/12/27.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "Casa 架构.h"

@implementation Casa___
#pragma mark - iOS应用架构谈 view层的组织和调用方案
/**
 
 [iOS应用架构谈 view层的组织和调用方案]
 https://casatwy.com/iosying-yong-jia-gou-tan-viewceng-de-zu-zhi-he-diao-yong-fang-an.html
 
 
 从概念上严格划分的话，服务端其实根本没有view，拜HTTP协议所赐，我们平时所讨论的View知识用于描述View的字符串（更实质的应该称之为数据），真正的View是浏览器。
 UIViewController中自带的那个view，它的主要任务就是作为一个容器。如果它所有的相关命名都改成ViewContainer，那么代码就会变成这样
 
 #MVC
 C应该做的事：
 1.管理View Container的生命周期
 2.负责生成所有的View实例，并放入View Container
 3.监听来自View与业务有关的事件，通过与Model的合作，来完成对应事件的业务
 M应该做的事：
 1.给ViewContoller提供数据
 2.给ViewController存储数据提供接口
 3.提供经过抽象的业务基础组件，供Controller调度
 V应该做的事：
 1.响应与业务无关的事件，并因此引发动画效果，点击反馈（如果合适的话，尽量还是放在View去做）等。
 2.界面元素表达
 
 #MVVM
 在ReactiveCocoa这个库成熟之后，ViewModel和View的信号机制在iOS下终于有了一个相对优雅的实现。MVVM本质上也是从MVC中派生出来的思想，MVVM着重想要解决的问题是尽可能的减少Controller的任务。
 Controller会随着软件的成长，变很大很难维护很难测试。MVCS是认为Controller做了一部分Model的事情，要把它拆出来变成Store，MVVM是认为Controller做了太多数据加工的事情，所以MVVM把数据加工的任务从Controller中解放了出来，使得Controller只需要专注于数据调配的工作，viewModel则去负责数据加工并通过通知机制让View响应ViewModel的改变。
 
 MVVM是基于胖Model的架构思路建立的，然后再胖Model中拆出两部分：Model和ViewModel。关于这一观点我要做一个额外解释：胖Model做的事情是先为Controller减负，然后由于Model变胖，再在此基础上拆出ViewModel，跟业界普遍认知的MVVM本质上是为Controller减负。
 另外，我前面说MVVM把数据加工的任务从Controller中解放出来，跟MVVM拆分的是胖Model也不矛盾。要做到解放Controller，首先你得有个胖Model，然后再把这个胖Model拆成Model和ViewModel。
 
 #数据从API到View的方法。
 
 #ReactiveCocoa更好的体现MVVM的精髓的地方：数据从view走向API或者Controller的方向上，就是ReactiveCocoa发挥的地方。
 
 我们知道，ViewModel本质上算是Model层（因为是胖Model里面分出来的一部分），所以View并不适合直接持有ViewModel，那么View一旦产生了数据了怎么办？扔信号扔给ViewModel，用谁扔？ReactiveCocoa。
 
 在MVVM中使用ReactiveCocoa有两个目的
 第一个目的就是如上所说，View并不适合直接持有ViewModel。
 第二个目的就在于，ViewModel有可能并不是只f服务于特定的一个View，使用更加松散的绑定关系能够降低ViewModel和View之间的耦合度。
 
 布局：Model VM Controller View
 
 归根结底就是一句话：在MVC的基础上，把C拆出一个ViewModel专门负责数据处理的事情，就是MVVM。
 
 **方案的效果应该是：
 
 业务方可以不用通过继承的方法，然后框架能够做到对ViewController的统一配置。
 业务方即使脱离框架环境，不需要修改任何代码也能够跑完代码。业务方的ViewController一旦丢入框架环境，不需要修改任何代码，框架就能够起到它应该起的作用。
 
 
 其实就是要实现不通过业务代码上对框架的主动迎合，使得业务能够被框架感知这样的功能。细化下来就是两个问题，框架要能够拦截到ViewController的生命周期，另一个问题就是，拦截的定义时机。
 
 对于方法拦截，很容易想到Method Swizzling，那么我们可以写一个实例，在App启动的时候添加针对UIViewController的方法拦截，这是一种做法。还有另一种做法就是，使用NSObject的load函数，在应用启动时自动监听。使用后者的好处在于，这个模块只要被项目包含，就能够发挥作用，不需要在项目里面添加任何代码。
 
 
 **然后另外一个要考虑的事情就是，原有的TMViewController（所谓的父类）也是会提供额外方法方便子类使用的，Method Swizzling只支持针对现有方法的操作，拓展方法的话，嗯，当然是用Category啦。
 
 我本人不赞成Category的过度使用，但鉴于Category是最典型的化继承为组合的手段，在这个场景下还是适合使用的。还有的就是，关于Method Swizzling手段实现方法拦截，业界也已经有了现成的开源库：Aspects，我们可以直接拿来使用。
 
 
 *拆分的心法
 天下功夫出少林，天下框架出MVC：
 拆分方式的不同诞生了各种不同的衍生架构方案（MVCS拆胖Controller，MVVM拆胖Model，VIPER什么都拆）
 
 *第一心法：保留最重要的任务，拆分其他不重要的任务
 *第二心法：拆分后的模块要尽可能提高可复用性，尽量做到DRY
 
 
 *设计心法
 第一心法：尽可能减少继承层级，涉及苹果原生对象的尽量不要继承
 第二心法：做好代码规范，规定好代码在文件中的布局，尤其是ViewController
 第三心法：能不放在Controller做的事情就尽量不要放在Controller里面去做
 第四心法：架构师是为业务工程师服务的，而不是去使唤业务工程师的
 
 小结
 其实针对View层的架构设计，还是要做好三点：代码规范，架构模式，工具集。
 
 代码规范对于View层来说意义重大，毕竟View层非常重业务，如果代码布局混乱，后来者很难接手，也很难维护。
 
 架构模式具体如何选择，完全取决于业务复杂度。如果业务相当相当复杂，那就可以使用VIPER，如果相对简单，那就直接MVC稍微改改就好了。每一种已经成为定式的架构模式不见得都适合各自公司对应的业务，所以需要各位架构师根据情况去做一些拆分或者改变。拆分一般都不会出现问题，改变的时候，只要别把MVC三个角色搞混就好了，M该做啥做啥，C该做啥做啥，V该做啥做啥，不要乱来。关于大部分的架构模式应该是什么样子，这篇文章里都已经说过了，不过我认为最重要的还是后面的心法，模式只是招术，熟悉了心法才能大巧不工。
 
 View层的工具集主要还是集中在如何对View进行布局，以及一些特定的View，比如带搜索提示的搜索框这种。这篇文章只提到了View布局的工具集，其它的工具集相对而言是更加取决于各自公司的业务的，各自实现或者使用CocoaPods里现成的都不是很难。
 
 对于小规模或者中等规模iOS开发团队来说，做好以上三点就足够了。在大规模团队中，有一个额外问题要考虑，就是跨业务页面调用方案的设计。
 
 【跨业务页面调用方案的设计】
 1.当一个需求需要多业务合作开发时，如果直接依赖，会导致某些依赖层上端的业务工程师在前期空转，依赖层下端的工程师任务繁重，而整个需求完成的速度会变慢，影响的是团队开发迭代速度。
 
 2.当要开辟一个新业务时，如果已有各业务间直接依赖，新业务又依赖某个旧业务，就导致新业务的开发环境搭建困难，因为必须要把所有相关业务都塞入开发环境，新业务才能进行开发。影响的是新业务的响应速度。
 
 3.当某一个被其他业务依赖的页面有所修改时，比如改名，涉及到的修改面就会特别大。影响的是造成任务量和维护成本都上升的结果。
 
 当然，如果App规模特别小，这三点带来的影响也会特别小，但是在阿里这样大规模的团队中，像天猫／淘宝这样大规模的App，一旦遇上这里面哪怕其中一件事情，就特么很坑爹。
 
 【解决方案】：让依赖关系下沉
 怎么让依赖关系下沉？引入Mediator模式。
 
 所谓引入Mediator模式来让依赖关系下沉，实质上就是每次呼唤页面的时候，通过一个中间人来召唤另外一个页面，这样只要每个业务依赖这个中间人就可以了，中间人的角色就可以放在业务层的下面一层，这就是依赖关系下沉。
 
 
 */

#pragma mark - 多态
/**
 【多态】
 https://casatwy.com/tiao-chu-mian-xiang-dui-xiang-si-xiang-er-duo-tai.html
 多态一般都要跟继承结合起来说，其本质是子类通过覆盖或重载（在下文里我会多次用到覆盖或重载）父类的方法，
 来使得对同一类对象同一方法的调用产生不同的结果。这里需要辨析的地方在：同一类对象指的是继承层级再上一层的对象，更加泛化。
 
 一般来说我们采用多态的场景还是很多的，有些在设计的时候就是用于继承的父类，希望子类覆盖自己的某些方法，然后才能够使程序正常运行下去。比如：
 BaseController需要它的子类去覆盖loadView等方法来执行view的显示逻辑
 BaseApiManager需要它的子类去覆盖methodName等方法来执行具体的API请求
 我们在实际采用多态的时候会有下面四种情况：
 
 1父类有部分public的方法是不需要，也不允许子类覆重
 2父类有一些特别的方法是必须要子类去覆重的，在父类的方法其实是个空方法
 3父类有一些方法是可选覆重的，一旦覆重，则以子类为准
 4父类有一些方法即便被覆重，父类原方法还是要执行的
 这四种情况在大多数支持多态的语言里面都没有做很好的原生限制，在程序规模逐渐变大的时候，会给维护代码的程序员带来各种各样的坑。
 
 
 解决方案1：
 IOP
 面向接口编程（Interface Oriented Programming, IOP）是解决这类问题比较好的一种思路。下面我们给大家看看应该如何使用OP解决上面的四种困境：
 
 
 
 解决方案2：
 多态
 总结是否决定应当使用多态的两个要素：
 
 如果引入多态之后导致对象角色不够单纯，那就不应当引入多态，如果引入多态之后依旧是单纯角色，那就可以引入多态
 如果要覆重的方法是角色业务的其中一个组成部分，例如split()和resort()，那么就最好不要用多态的方案，用IOP，因为在外界调用的时候其实并不需要通过多态来满足定制化的需求。
 
 其实这是一个角色问题，越单纯的角色就越容易维护。还有一个就是区分被覆重的方法是否需要被外界调用的问题。好了，现在我们回到这一节前面提出的两个问题：何时引入接入点和何时采用覆重。针对第一个问题架构师一定要分清楚角色，在保证角色单纯的情况下可以引入多态。另外一点要考虑被覆重的方法是否需要被外界使用，还是只是父类运行时需要子类通过覆重提供中间数据的。如果是只要子类通过覆重提供中间数据的，一律应当采用IOP而不是多态。
 
 
 
 【关于APO】
 AOP（Aspect Oriented Programming），面向切片编程。
 
 如何实现AOP？
 AOP一般都是需要有一个拦截器，然后在每一个切片运行之前和运行之后（或者任何你希望的地方），通过调用拦截器的方法来把这个jointpoint扔到外面，在外面获得这个jointpoint的时候，执行相应的代码。
 
 在iOS开发领域，objective-C的runtime有提供了一系列的方法，能够让我们拦截到某个方法的调用，来实现拦截器的功能，这种手段我们称为Method Swizzling。Aspects通过这个手段实现了针对某个类和某个实例中方法的拦截。
 
 另外，也可以使用protocol的方式来实现拦截器的功能，具体实现方案就是这样：
 @protocol RTAPIManagerInterceptor <NSObject>
 
 @optional
 - (void)manager:(RTAPIBaseManager *)manager beforePerformSuccessWithResponse:(AIFURLResponse *)response;
 - (void)manager:(RTAPIBaseManager *)manager afterPerformSuccessWithResponse:(AIFURLResponse *)response;
 
 - (void)manager:(RTAPIBaseManager *)manager beforePerformFailWithResponse:(AIFURLResponse *)response;
 - (void)manager:(RTAPIBaseManager *)manager afterPerformFailWithResponse:(AIFURLResponse *)response;
 
 - (BOOL)manager:(RTAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
 - (void)manager:(RTAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;
 
 @end
 
 @interface RTAPIBaseManager : NSObject
 
 @property (nonatomic, weak) id<RTAPIManagerInterceptor> interceptor;
 
 @end
 这么做对比Method Swizzling有个额外好处就是，你可以通过拦截器来给拦截器的实现者提供更多的信息，便于外部实现更加了解当前切片的情况。另外，你还可以更精细地对切片进行划分。Method Swizzling的切片粒度是函数粒度的，自己实现的拦截器的切片粒度可以比函数更小，更加精细。
 
 缺点就是，你得自己在每一个插入点把调用拦截器方法的代码写上（笑），通过Aspects（本质上就是Mehtod Swizzling）来实现的AOP，就能轻松一些。
 
 
 
 */



#pragma mark - 组件化
/**
 【组件化】
 https://casatwy.com/iOS-Modulization.html
 
 基于Mediator模式和Target-Action模式，中间采用了runtime来完成调用。
 这套组件化方案将远程应用调用和本地应用调用做了拆分，而且是由本地应用调用做了拆分，而且由本地应用调用为远程应用调用提供服务，与蘑菇街方案正好相反。
 
 APP中做路由解析可以做的简单点，制定URL规则就能完成，scheme://target/action
 
 所有组件都通过组件自带的Target-Action来响应，也就是说，模块与模块之间的接口被固话在了Target-Action这一层，避免了实施组件化的改造过程中，对Business的侵入，同时也提高了组件化接口的可维护性。
 
 
 复杂参数和非常规参数，以及组件化相关设计思路
 非常规参数例如：UIImage等这些不能够被json解析的类型。
 
 */

#pragma mark - 组件化工具
/**
 作者：Casa Taloyum
 [CTMediator的使用]
 https://www.jianshu.com/p/76132c91be47
 
 解耦
 
 底层是通过Runtime的消息转发，然后通过performance selector实现的
 1.从NSString生成选择子的方法：
 SEL action = NSSelectorFromString(@"Action_response:");
 
 2.从NSString生成对象的方法：
 NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
 
 3.方法签名生成的方法
 NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
 
 4.[target performSelector:action withObject:params];
 
 
 作者：蘑菇街
 [MGRouter]
 蘑菇街是以两种方式来做跨组件操作的
 1.MGJRouter的registerURLPattern：toHandler：进行注册，将URL和block绑定。
 这个方法前面一个参数传递的是URL，
 例如mgj://detail?id=:id这种，
 后面的toHandler:传递的是一个^(NSDictionary *routerParameters){//此处可以做任何事情}的block。
 生成一个装满URL的源码文件。
 2.第二种注册方式，可以传递非常规参数，新开了一个对象叫做ModuleManager，提供了一个registerClass:forProtocol:的方法，在应用启动时，各组件都会有一个专门的ModuleEntry被唤起，然后moduleEntry将@protocol和Class进行配对。因此ModuleManager中就有了一个字典来记录这个配对。
 当有涉及非常规参数的调动时，业务方就不会去使用[MGJRouter openURL:@"mgj://detail?id=404"]的方案了，转而采用ModuleManager的classForProtocol:方法。业务传入一个@protocol给ModuleManager，然后业务方再自己执行alloc和init方法得到一个符合刚才传入@protocol的对象，然后再执行相应的逻辑。
 
 
 */
#pragma mark - 继承
/**
 继承
 https://casatwy.com/tiao-chu-mian-xiang-dui-xiang-si-xiang-yi-ji-cheng.html
 解决方案：用组合替代继承
 搜索框：将Textfielde和search逻辑模块拆开，然后通过定义好的接口进行交互，一般来说可以选择Delegate模式来交互。
 这样一来，搜索框和搜索逻辑分别形成了两个不同的组件，分别在HOME_SEARCH_BAR, PAGE_SEARCH_BAR, LOCAL_SEARCH_BAR中以不同的形态组合而成。 textField和SEARCH_LOGIC<search_protocol>之间通过delegate的模式进行数据交互。 这样就解决了上面提到的两种类型的问题。 大部分我们通过代码复用来选择继承的情况，其实都是变成组合比较好。 因此我在团队中一直在推动使用组合来代替继承的方案。 那么什么时候继承才有用呢？
 
 纠结了一下，貌似实在是没什么地方非要用继承不可的。但事实上使用继承，我们得要分清楚层次，使用继承其实是如何给一类对象划分层次的问题。在正确的继承方式中，父类应当扮演的是底层的角色，子类是上层的业务。举两个例子：
 
 
 
 Object -> Model
 Object -> View
 Object -> Controller
 
 ApiManager -> DetailManager
 ApiManager -> ListManager
 ApiManager -> CityManager
 
 1.父类只是给子类提供服务，并不涉及子类的业务逻辑
 
 Object并不影响Model, View, Controller的执行逻辑和业务
 Object为子类提供基础服务，例如内存计数等
 
 ApiManager并不影响其他的Manager
 ApiManager只是给派生的Manager提供服务而已,ApiManager做的只会是份内的是，对于子类做的事情不参与。
 
 2.层级关系明显，功能划分清晰，父类和子类各做各的。
 
 Object并不参与MVC的管理中，那些都只是各自派生类自己要处理的事情
 
 DetailManager, ListManager, CityManager都只是处理各自业务的对象
 ApiManager并不应该涉足对应的业务。
 
 3.父类的所有变化，都需要在子类中体现，也就是说此时耦合已经成为需求
 
 Object对类的描述，对内存引用的计数方式等，都是普遍影响派生类的。
 ApiManager中对于网络请求的发起，网络状态的判断，是所有派生类都需要的。
 此时，牵一发动全身就已经成为了需求，是适用继承的
 
 【总结】
 可见，代码复用也是分类别的，如果当初只是出于代码复用的目的而不区分类别和场景，就采用继承是不恰当的。我们应当考虑以上3点要素看是否符合，才能决定是否使用继承。就目前大多数的开发任务来看，继承出现的场景不多，主要还是代码复用的场景比较多，然而通过组合去进行代码复用显得要比继承麻烦一些，因为组合要求你有更强的抽象能力，继承则比较符合直觉。然而从未来可能产生的需求变化和维护成本来看，使用组合其实是很值得的。另外，当你发现你的继承超过2层的时候，你就要好好考虑是否这个继承的方案了，第三层继承正是滥用的开端。确定有必要之后，再进行更多层次的继承。
 
 所以我的态度是：万不得已不要用继承，优先考虑组合
 
 */



#pragma mark - 封装
/**
 
 封装
 1. 将数据结构和函数放在一起是否真的合理？
 函数就是做事情的，它们有输入，有执行逻辑，有输出。 数据结构就是用来表达数据的，要么作为输入，要么作为输出。
 2.是否所有的东西都需要对象化？
 3.类型爆炸
 派生非常不好控制
 把执行和数据拆解开，就不需要那么多viewcontroller了，派生只是给对象添加属性和方法。但事实上是这样：
 
 struct A {              Class A extends B
 struct B b;         {
 int number;             int number;
 }                       {
 前者和后者的相同点是：在内存中，它们的数值部分的布局是一模一样的。不同点是：前者更强烈地表达了组合，后者更强烈地表达的是继承。然而我们都知道一个常识：组合要比继承更加合适，这在我这一系列的第一篇文章中有提到。
 
 上两者的表达在内存中没有任何不同，但在实际开发阶段中，后者会更容易把项目引入一个坏方向。
 
 【总结】
 1.它能够非常好地进行代码复用
 2.它能够非常方便地应对复杂代码
 3.在进行程序设计时，面向对象更加符合程序员的直觉
 
 
 
 */
@end
