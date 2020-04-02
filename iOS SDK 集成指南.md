##iOS SDK 集成指南
------------------------
## SDK 概述

 - 此 SDK 整合了三大运营商的网关认证能力，为开发者提供了一键登录功能，优化用户注册/登录、号码验证体验，提高安全性
 - 主要场景： 注册, 登陆, 验证
 - 目前 SDK 只支持iOS 8以上版本的手机系统

###接入配置

手动导入 SDK 到工程中:

拖动 demo 中的 `Frameworks` 文件夹到自己的工程中, 勾选 `Copy items if needed`  
__注:__ `Frameworks` 文件夹 含有
`QuickLogin.framework`, `TYRZSDK.framework`, `EAccountApiSDK.framework`, `account_login_sdk_noui_core.framework`

为工程添加相应的Frameworks，需要为项目添加的Frameworks如下

```
CoreLocation.framework
CFNetwork.framework
CoreFoundation.framework
libresolv.tbd
libz.tbd
libc++.1.tbd
CoreTelephony.framework
SystemConfiguration.framework
Security.framework
CoreGraphics.framework
libsqlite3.tbd
MobileCoreServices.framework

TYRZSDK.framework
account_login_sdk_noui_core.framework
EAccountApiSDK.framework
QuickLogin.framework

```

工程配置
配置-ObjC
设置工程 TARGETS -> Build Settings -> Other Links Flags， 设置 -ObjC

配置支持Http传输
右键打开工程plist文件，加入以下代码

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
配置资源
如有需要. 请将演示 Demo 中 `Assets.xcassets` 图片资源复制到自己的工程。

###接入使用

Swift 接入
创建桥接头文件
如果你的Swift工程还未引入过Objective-C文件，需要创建一个以工程名称-Bridging-Header.h文件 

配置路径
设置工程 TARGETS -> Build Settings -> Objective-C Bridging Header， 设置桥接文件工程名称-Bridging-Header.h的相对路径 

引入头文件
在工程名称-Bridging-Header.h文件中引入头文件

Objective-C 接入

需要引用 `#import <QuickLogin/QLHelper.h>` 头文件, 并进行初始化

```
UPAuthConfig *config = [[UPAuthConfig alloc] init];
config.appKey = @"appkey";
config.timeout = 5000;
config.authBlock = ^(NSDictionary *result) {
    NSLog(@"初始化结果 result:%@", result);
};
[QLHelper setupWithConfig:config];
```


###运行Demo
下载 Demo 后. 修改 `bundle id` 和 `appkey` 为自己的, 直接运行
###相关 API
#### SDK 类说明

1. QLHelper, SDK 入口
2. UPAuthConfig, 应用配置信息类
3. UPUIConfig, 登录界面UI配置基类
4. UPLayoutConstraint, 认证界面控件布局类
5. UPLayoutItem, 布局参照枚举

#### QLHelper 的主要方法,详见 `QLHelper.h` 文件

```
/// 初始化 SDK
+ (void)setupWithConfig:(UPAuthConfig *)config;

/**
 初始化过程是否完成
 * 完成YES, 未完成NO
 */
+ (BOOL)isSetupClient;

/**
 获取手机号校验token。和+ (void)getToken:(void (^)(NSDictionary *result))completion;实现的功能一致
 @param timeout 超时。单位ms,默认为5000ms。合法范围(0,10000]
 @param completion token相关信息。
 */
+ (void)getToken:(NSTimeInterval)timeout completion:(void (^)(NSDictionary *result))completion;

/**
 授权登录 预取号
 @param timeout 超时。单位ms,默认为5000ms。合法范围(0,10000]
 @param completion 预取号结果
 */
+ (void)preLogin:(NSTimeInterval)timeout completion:(void (^)(NSDictionary *result))completion;

/**
 授权登录
 @param vc 当前控制器
 @param hide 完成后是否自动隐藏授权页。
 @param animationFlag 拉起授权页时是否需要动画效果，默认YES
 @param timeout 超时。单位毫秒，合法范围是(0,30000]，默认值为10000。此参数同时作用于拉起授权页超时 ，以及点击授权页登录按钮获取LoginToken超时
 @param completion 登录结果
 @parm  actionBlock 授权页事件触发回调。 type事件类型，content事件描述。详细见文档
 */
+ (void)getAuthorizationWithController:(UIViewController *)vc
                                  hide:(BOOL)hide
                              animated:(BOOL)animationFlag
                               timeout:(NSTimeInterval)timeout
                            completion:(void (^)(NSDictionary *result))completion
                           actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock;
/**
隐藏登录页.当授权页被拉起以后，可调用此接口隐藏授权页。当一键登录自动隐藏授权页时，不建议调用此接口
@param flag 隐藏时是否需要动画
@param completion 授权页隐藏完成后回调。
*/
+ (void)dismissLoginControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

/*!
 * @abstract 设置是否打印sdk产生的Debug级log信息, 默认为NO(不打印log)
 *
 * SDK 默认开启的日志级别为: Info. 只显示必要的信息, 不打印调试日志.
 *
 * 请在SDK启动后调用本接口，调用本接口可打开日志级别为: Debug, 打印调试日志.
 * 请在发布产品时改为NO，避免产生不必要的IO
 */
+ (void)setDebug:(BOOL)enable;

/*!
 * @abstract 判断当前手机网络环境是否支持认证
 * YES 支持, NO 不支持
 */
+ (BOOL)checkVerifyEnable;

/*!
 * @abstract 清除预取号缓存
 */
+ (void)clearPreLoginCache;

/**
 自定义登录页UI样式参数
 @param UIConfig  UIConfig对象实例。仅使用UPUIConfig类型对象
 @param customViewsBlk 添加自定义视图block
*/
+ (void)customUIWithConfig:(UPUIConfig *)UIConfig customViews:(void(^)(UIView *customAreaView))customViewsBlk;

```

#### UPUIConfig SDK 自定义授权页面UI样式配置 和 添加自定义控件,详见 `QLHelper.h` 文件

**<font color=red size=4>__注意:__ 开发者不得通过任何技术手段将授权页面的隐私协议栏、slogan隐藏或者覆盖，对于接入一键认证SDK并上线的应用，我方会对上线的应用授权页面做审查，如果发现未按要求设计授权页面，将关闭应用的一键登录服务。</font>**

```
UPUIConfig *config = [[UPUIConfig alloc] init];
[QLHelper customUIWithConfig:config customViews:^(UIView *customAreaView) {

}];
/// 详细具体的使用. 
/// 建议参考 demo 中的 ViewController.m 中 customFullScreenUI 和 customWindowUI 方法

```

#### UPUIConfig类

授权界面UI配置属性说明：

*   授权页面设置
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">authPageBackgroundImage</td>
<td align="center">UIImage</td>
<td align="center">授权界面背景图片</td>
</tr>
<tr>
<td align="center">autoLayout</td>
<td align="center">BOOL</td>
<td align="center">是否使用autoLayout，默认YES，</td>
</tr>
<tr>
<td align="center">shouldAutorotate</td>
<td align="center">BOOL</td>
<td align="center">是否支持自动旋转 默认YES</td>
</tr>
<tr>
<td align="center">orientation</td>
<td align="center">UIInterfaceOrientation</td>
<td align="center">设置进入授权页的屏幕方向，不支持UIInterfaceOrientationPortraitUpsideDown</td>
</tr>
<tr>
<td align="center">modalTransitionStyle</td>
<td align="center">UIModalTransitionStyle</td>
<td align="center">授权页弹出方式,弹窗模式下不支持 UIModalTransitionStylePartialCurl</td>
</tr>
<tr>
<td align="center">dismissAnimationFlag</td>
<td align="center">BOOL</td>
<td align="center">关闭授权页是否有动画。默认YES,有动画。参数仅作用于以下两种情况：1、一键登录接口设置登录完成后，自动关闭授权页 2、用户点击授权页关闭按钮，关闭授权页</td>
</tr>
</tbody>
</table>

*   导航栏
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">navCustom</td>
<td align="center">BOOL</td>
<td align="center">是否隐藏导航栏（适配全屏图片）</td>
</tr>
<tr>
<td align="center">navColor</td>
<td align="center">UIColor</td>
<td align="center">导航栏颜色</td>
</tr>
<tr>
</tr>
<tr>
<td align="center">preferredStatusBarStyle</td>
<td align="center">UIStatusBarStyle</td>
<td align="center">授权页 preferred status bar style，取代barStyle参数</td>
</tr>
<tr>
<td align="center">navText</td>
<td align="center">NSAttributedString</td>
<td align="center">导航栏标题</td>
</tr>
<tr>
<td align="center">navReturnImg</td>
<td align="center">UIImage</td>
<td align="center">导航返回图标</td>
</tr>
<tr>
<td align="center">navControl</td>
<td align="center">UIBarButtonItem</td>
<td align="center">导航栏右侧自定义控件</td>
</tr>
<tr>
<td align="center">prefersStatusBarHidden</td>
<td align="center">BOOL</td>
<td align="center">竖屏情况下，是否隐藏状态栏。默认NO.在项目的Info.plist文件里设置UIViewControllerBasedStatusBarAppearance为YES.注意：弹窗模式下无效，是否隐藏由外部控制器控制</td>
</tr>
<tr>
<td align="center">navTransparent</td>
<td align="center">BOOL</td>
<td align="center">导航栏是否透明，默认不透明。此参数和navBarBackGroundImage冲突，应避免同时使用</td>
</tr>
<tr>
<td align="center">navReturnHidden</td>
<td align="center">BOOL</td>
<td align="center">导航栏默认返回按钮隐藏，默认不隐藏</td>
</tr>
<tr>
<td align="center">navReturnImageEdgeInsets</td>
<td align="center">UIEdgeInsets</td>
<td align="center">导航栏返回按钮图片缩进,默认为UIEdgeInsetsZero</td>
</tr>
<tr>
<td align="center">navDividingLineHidden</td>
<td align="center">BOOL</td>
<td align="center">导航栏分割线是否隐藏，默认隐藏</td>
</tr>
<tr>
<td align="center">navBarBackGroundImage</td>
<td align="center">UIImage</td>
<td align="center">导航栏背景图片.此参数和navTransparent冲突，应避免同时使用</td>
</tr>
</tbody>
</table>

*   LOGO
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">logoImg</td>
<td align="center">UIImage</td>
<td align="center">LOGO图片</td>
</tr>
<tr>
<td align="center">logoWidth</td>
<td align="center">CGFloat</td>
<td align="center">LOGO图片宽度</td>
</tr>
<tr>
<td align="center">logoHeight</td>
<td align="center">CGFloat</td>
<td align="center">LOGO图片高度</td>
</tr>
<tr>
<td align="center">logoOffsetY</td>
<td align="center">CGFloat</td>
<td align="center">LOGO图片偏移量</td>
</tr>
<tr>
<td align="center">logoConstraints</td>
<td align="center">NSArray</td>
<td align="center">LOGO图片布局对象</td>
</tr>
<tr>
<td align="center">logoHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">LOGO图片 横屏布局，横屏时优先级高于logoConstraints</td>
</tr>
<tr>
<td align="center">logoHidden</td>
<td align="center">BOOL</td>
<td align="center">LOGO图片隐藏</td>
</tr>
</tbody>
</table>

*   登录按钮
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">logBtnText</td>
<td align="center">NSString</td>
<td align="center">登录按钮文本</td>
</tr>
<tr>
<td align="center">logBtnOffsetY</td>
<td align="center">CGFloat</td>
<td align="center">登录按钮Y偏移量</td>
</tr>
<tr>
<td align="center">logBtnConstraints</td>
<td align="center">NSArray</td>
<td align="center">登录按钮布局对象</td>
</tr>
<tr>
<td align="center">logBtnHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">登录按钮 横屏布局，横屏时优先级高于logBtnConstraints</td>
</tr>
<tr>
<td align="center">logBtnTextColor</td>
<td align="center">UIImage</td>
<td align="center">登录按钮文本颜色</td>
</tr>
<tr>
<td align="center">logBtnFont</td>
<td align="center">UIFont</td>
<td align="center">登录按钮字体，默认跟随系统</td>
</tr>
<tr>
<td align="center">logBtnImgs</td>
<td align="center">UIColor</td>
<td align="center">登录按钮背景图片添加到数组(顺序如下) @[激活状态的图片,失效状态的图片,高亮状态的图片]</td>
</tr>
</tbody>
</table>

*   手机号码
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">numberColor</td>
<td align="center">UIColor</td>
<td align="center">手机号码字体颜色</td>
</tr>
<tr>
<td align="center">numberSize</td>
<td align="center">CGFloat</td>
<td align="center">手机号码字体大小</td>
</tr>
<tr>
<td align="center">numberFont</td>
<td align="center">UIFont</td>
<td align="center">手机号码字体，优先级高于numberSize</td>
</tr>
<tr>
<td align="center">numFieldOffsetY</td>
<td align="center">CGFloat</td>
<td align="center">号码栏Y偏移量</td>
</tr>
<tr>
<td align="center">numberConstraints</td>
<td align="center">NSArray</td>
<td align="center">号码栏布局对象</td>
</tr>
<tr>
<td align="center">numberHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">号码栏 横屏布局,横屏时优先级高于numberConstraints</td>
</tr>
</tbody>
</table>

*   checkBox
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">uncheckedImg</td>
<td align="center">UIImage</td>
<td align="center">checkBox未选中时图片</td>
</tr>
<tr>
<td align="center">checkedImg</td>
<td align="center">UIImage</td>
<td align="center">checkBox选中时图片</td>
</tr>
<tr>
<td align="center">checkViewConstraints</td>
<td align="center">NSArray</td>
<td align="center">checkBox布局对象</td>
</tr>
<tr>
<td align="center">checkViewHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">checkBox横屏布局，横屏优先级高于checkViewConstraints</td>
</tr>
<tr>
<td align="center">checkViewHidden</td>
<td align="center">BOOL</td>
<td align="center">checkBox是否隐藏，默认不隐藏</td>
</tr>
<tr>
<td align="center">privacyState</td>
<td align="center">BOOL</td>
<td align="center">隐私条款check框默认状态 默认:NO</td>
</tr>
</tbody>
</table>

*   隐私协议栏
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">appPrivacyOne</td>
<td align="center">NSArray</td>
<td align="center">隐私条款一:数组（务必按顺序）@[条款名称,条款链接]</td>
</tr>
<tr>
<td align="center">appPrivacyTwo</td>
<td align="center">NSArray</td>
<td align="center">隐私条款二:数组（务必按顺序）@[条款名称,条款链接]</td>
</tr>
<tr>
<td align="center">appPrivacyColor</td>
<td align="center">UIImage</td>
<td align="center">隐私条款名称颜色 @[基础文字颜色,条款颜色]</td>
</tr>
<tr>
<td align="center">privacyTextFontSize</td>
<td align="center">CGFloat</td>
<td align="center">隐私条款字体大小，默认12</td>
</tr>
<tr>
<td align="center">privacyOffsetY</td>
<td align="center">CGFloat</td>
<td align="center">隐私条款Y偏移量(注:此属性为与屏幕底部的距离)</td>
</tr>
<tr>
<td align="center">privacyComponents</td>
<td align="center">NSArray</td>
<td align="center">隐私条款拼接文本数组</td>
</tr>
<tr>
<td align="center">privacyConstraints</td>
<td align="center">NSArray</td>
<td align="center">隐私条款布局对象</td>
</tr>
<tr>
<td align="center">privacyHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">隐私条款 横屏布局，横屏下优先级高于privacyConstraints</td>
</tr>
<tr>
<td align="center">privacyTextFontSize</td>
<td align="center">CGFloat</td>
<td align="center">隐私条款字体大小，默认12</td>
</tr>
<tr>
<td align="center">privacyTextAlignment</td>
<td align="center">NSTextAlignment</td>
<td align="center">隐私条款文本对齐方式，目前仅支持 left、center</td>
</tr>
<tr>
<td align="center">privacyShowBookSymbol</td>
<td align="center">BOOL</td>
<td align="center">隐私条款是否显示书名号，默认不显示</td>
</tr>
<tr>
<td align="center">privacyLineSpacing</td>
<td align="center">CGFloat</td>
<td align="center">隐私条款行距，默认跟随系统</td>
</tr>
<tr>
<td align="center">customPrivacyAlertViewBlock</td>
<td align="center">Block类型</td>
<td align="center">自定义Alert view,当隐私条款未选中时,点击登录按钮时回调。当此参数存在时,未选中隐私条款的情况下，登录按钮可以被点击，block内部参数为自定义Alert view可被添加的控制器，详细用法可参见示例demo</td>
</tr>
</tbody>
</table>

*   隐私协议页面
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">agreementNavBackgroundColor</td>
<td align="center">UIColor</td>
<td align="center">协议页导航栏背景颜色</td>
</tr>
<tr>
<td align="center">agreementNavText</td>
<td align="center">NSAttributedString</td>
<td align="center">运营商协议的协议页面导航栏标题</td>
</tr>
<tr>
<td align="center">firstPrivacyAgreementNavText</td>
<td align="center">NSAttributedString</td>
<td align="center">自定义协议1的协议页面导航栏标题</td>
</tr>
<tr>
<td align="center">secondPrivacyAgreementNavText</td>
<td align="center">NSAttributedString</td>
<td align="center">自定义协议2的协议页面导航栏标题</td>
</tr>
<tr>
<td align="center">agreementNavReturnImage</td>
<td align="center">UIImage</td>
<td align="center">协议页导航栏返回按钮图片</td>
</tr>
<tr>
<td align="center">agreementPreferredStatusBarStyle</td>
<td align="center">UIStatusBarStyle</td>
<td align="center">协议页 preferred status bar style，取代barStyle参数</td>
</tr>
</tbody>
</table>

*   slogan
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">sloganOffsetY</td>
<td align="center">CGFloat</td>
<td align="center">slogan偏移量Y</td>
</tr>
<tr>
<td align="center">sloganConstraints</td>
<td align="center">NSArray</td>
<td align="center">slogan布局对象</td>
</tr>
<tr>
<td align="center">sloganHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">slogan 横屏布局,横屏下优先级高于sloganConstraints</td>
</tr>
<tr>
<td align="center">sloganTextColor</td>
<td align="center">UIColor</td>
<td align="center">slogan文字颜色</td>
</tr>
<tr>
<td align="center">sloganFont</td>
<td align="center">UIFont</td>
<td align="center">slogan文字font,默认12</td>
</tr>
</tbody>
</table>

*   loading
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">loadingConstraints</td>
<td align="center">NSArray</td>
<td align="center">loading布局对象</td>
</tr>
<tr>
<td align="center">loadingHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">默认loading 横屏布局，横屏下优先级高于loadingConstraints</td>
</tr>
<tr>
<td align="center">customLoadingViewBlock</td>
<td align="center">Block类型</td>
<td align="center">自定义loading view,当授权页点击登录按钮时回调。当此参数存在时,默认loading view不会显示,需开发者自行设计loading view。block内部参数为自定义loading view可被添加的父视图，详细用法可参见示例demo</td>
</tr>
</tbody>
</table>

*   弹窗
<table>
<thead>
<tr>
<th align="center">参数名称</th>
<th align="center">参数类型</th>
<th align="center">参数说明</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">showWindow</td>
<td align="center">BOOL</td>
<td align="center">是否弹窗，默认no</td>
</tr>
<tr>
<td align="center">windowBackgroundImage</td>
<td align="center">UIImage</td>
<td align="center">弹框内部背景图片</td>
</tr>
<tr>
<td align="center">windowBackgroundAlpha</td>
<td align="center">CGFloat</td>
<td align="center">弹窗外侧 透明度  0~1.0</td>
</tr>
<tr>
<td align="center">windowCornerRadius</td>
<td align="center">CGFloat</td>
<td align="center">弹窗圆角数值</td>
</tr>
<tr>
<td align="center">windowConstraints</td>
<td align="center">NSArray</td>
<td align="center">弹窗布局对象</td>
</tr>
<tr>
<td align="center">windowHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">弹窗横屏布局，横屏下优先级高于windowConstraints</td>
</tr>
<tr>
<td align="center">windowCloseBtnImgs</td>
<td align="center">NSArray</td>
<td align="center">弹窗close按钮图片 @[普通状态图片，高亮状态图片]</td>
</tr>
<tr>
<td align="center">windowCloseBtnConstraints</td>
<td align="center">NSArray</td>
<td align="center">弹窗close按钮布局</td>
</tr>
<tr>
<td align="center">windowCloseBtnHorizontalConstraints</td>
<td align="center">NSArray</td>
<td align="center">弹窗close按钮 横屏布局,横屏下优先级高于windowCloseBtnConstraints</td>
</tr>
</tbody>
</table>



### 错误码列表

<table>
<thead>
<tr>
<th align="center">code</th>
<th align="center">描述</th>
<th align="center">备注</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">1000</td>
<td align="center">verify consistent</td>
<td align="center">手机号验证一致</td>
</tr>
<tr>
<td align="center">1001</td>
<td align="center">verify not consistent</td>
<td align="center">手机号验证不一致</td>
</tr>
<tr>
<td align="center">1002</td>
<td align="center">unknown result</td>
<td align="center">未知结果</td>
</tr>
<tr>
<td align="center">1003</td>
<td align="center">token expired</td>
<td align="center">token失效</td>
</tr>
<tr>
<td align="center">1004</td>
<td align="center">sdk verify has been closed</td>
<td align="center">SDK发起认证未开启</td>
</tr>
<tr>
<td align="center">1005</td>
<td align="center">AppKey 不存在</td>
<td align="center">请到官网检查 Appkey 对应的应用是否已被删除</td>
</tr>
<tr>
<td align="center">1006</td>
<td align="center">frequency of verifying single number is beyond the maximum limit</td>
<td align="center">同一号码自然日内认证消耗超过限制</td>
</tr>
<tr>
<td align="center">1007</td>
<td align="center">beyond daily frequency limit</td>
<td align="center">appKey自然日认证消耗超过限制</td>
</tr>
<tr>
<td align="center">1008</td>
<td align="center">AppKey 非法</td>
<td align="center">请到官网检查此应用详情中的 Appkey，确认无误</td>
</tr>
<tr>
<td align="center">1009</td>
<td align="center">当前的 Appkey 下没有创建 iOS 应用；你所使用的 JCore 版本过低</td>
<td align="center">请到官网检查此应用的应用详情；更新应用中集成的 JCore 至最新。</td>
</tr>
<tr>
<td align="center">1010</td>
<td align="center">verify interval is less than the minimum limit</td>
<td align="center">同一号码连续两次提交认证间隔过短</td>
</tr>
<tr>
<td align="center">2000</td>
<td align="center">token request success</td>
<td align="center">获取token 成功</td>
</tr>
<tr>
<td align="center">2001</td>
<td align="center">fetch token error</td>
<td align="center">获取token失败</td>
</tr>
<tr>
<td align="center">2002</td>
<td align="center">sdk init failed</td>
<td align="center">sdk初始化失败</td>
</tr>
<tr>
<td align="center">2003</td>
<td align="center">netwrok not reachable</td>
<td align="center">网络连接不通</td>
</tr>
<tr>
<td align="center">2004</td>
<td align="center">get uid failed</td>
<td align="center">极光服务注册失败</td>
</tr>
<tr>
<td align="center">2005</td>
<td align="center">request timeout</td>
<td align="center">请求超时</td>
</tr>
<tr>
<td align="center">2006</td>
<td align="center">fetch config failed</td>
<td align="center">获取配置失败</td>
</tr>
<tr>
<td align="center">2008</td>
<td align="center">Token requesting, please wait</td>
<td align="center">正在获取token中，稍后再试</td>
</tr>
<tr>
<td align="center">2009</td>
<td align="center">verifying, please try again later</td>
<td align="center">正在认证中，稍后再试</td>
</tr>
<tr>
<td align="center">2014</td>
<td align="center">internal error while requesting token</td>
<td align="center">请求token时发生内部错误</td>
</tr>
<tr>
<td align="center">2015</td>
<td align="center">rsa encode failed</td>
<td align="center">rsa加密失败</td>
</tr>
<tr>
<td align="center">2016</td>
<td align="center">network type not supported</td>
<td align="center">当前网络环境不支持认证</td>
</tr>
<tr>
<td align="center">2017</td>
<td align="center">carrier config invalid</td>
<td align="center">运营商配置无效</td>
</tr>
<tr>
<td align="center">4001</td>
<td align="center"></td>
<td align="center">参数错误。请检查参数，比如是否手机号格式不对</td>
</tr>
<tr>
<td align="center">4009</td>
<td align="center"></td>
<td align="center">解密rsa失败</td>
</tr>
<tr>
<td align="center">4014</td>
<td align="center">appkey is blocked</td>
<td align="center">功能被禁用</td>
</tr>
<tr>
<td align="center">4018</td>
<td align="center"></td>
<td align="center">没有足够的余额</td>
</tr>
<tr>
<td align="center">4031</td>
<td align="center"></td>
<td align="center">不是认证用户</td>
</tr>
<tr>
<td align="center">4032</td>
<td align="center"></td>
<td align="center">获取不到用户配置</td>
</tr>
<tr>
<td align="center">4033</td>
<td align="center">Login feature is not available</td>
<td align="center">未开启一键登录</td>
</tr>
<tr>
<td align="center">6000</td>
<td align="center">loginToken request success</td>
<td align="center">获取loginToken成功</td>
</tr>
<tr>
<td align="center">6001</td>
<td align="center">fetch loginToken failed</td>
<td align="center">获取loginToken失败</td>
</tr>
<tr>
<td align="center">6002</td>
<td align="center">login cancel</td>
<td align="center">用户取消登录</td>
</tr>
<tr>
<td align="center">6003</td>
<td align="center">UI load error</td>
<td align="center">UI加载异常</td>
</tr>
<tr>
<td align="center">6004</td>
<td align="center">authorization requesting, please try again later</td>
<td align="center">正在登录中，稍候再试</td>
</tr>
<tr>
<td align="center">6006</td>
<td align="center">prelogin scrip expired</td>
<td align="center">预取号信息过期，请重新预取号</td>
</tr>
<tr>
<td align="center">7000</td>
<td align="center">preLogin success</td>
<td align="center">预取号成功</td>
</tr>
<tr>
<td align="center">7001</td>
<td align="center">preLogin failed</td>
<td align="center">预取号失败</td>
</tr>
<tr>
<td align="center">7002</td>
<td align="center">preLogin requesting, please try again later</td>
<td align="center">取号中</td>
</tr>
<tr>
<td align="center">8000</td>
<td align="center">init success</td>
<td align="center">初始化成功</td>
</tr>
<tr>
<td align="center">8004</td>
<td align="center">init failed</td>
<td align="center">初始化失败</td>
</tr>
<tr>
<td align="center">8005</td>
<td align="center">init timeout</td>
<td align="center">初始化超时</td>
</tr>
</tbody>
</table></article>
    <footer>



