//
//  QLHelper.h
//  QuickLogin
//
//  Created by lingang on 2020/2/14.
//  Copyright © 2020 upyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UP_VERSION_NUMBER 1.0.0

typedef void (^UPPrivacyAlertViewBlock)(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void));


/**
 UPLayoutConstraint 布局参照item

 - UPLayoutItemNone: 不参照任何item。可用来直接设置width、height
 - UPLayoutItemLogo:  参照logo视图
 - UPLayoutItemNumber: 参照号码栏
 - UPLayoutItemSlogan: 参照标语栏
 - UPLayoutItemLogin: 参照登录按钮
 - UPLayoutItemCheck: 参照隐私选择框
 - UPLayoutItemPrivacy: 参照隐私栏
 - UPLayoutItemSuper: 参照父视图
 */
typedef NS_ENUM(NSUInteger, UPLayoutItem) {
    UPLayoutItemNone = 1,
    UPLayoutItemLogo,
    UPLayoutItemNumber,
    UPLayoutItemSlogan,
    UPLayoutItemLogin,
    UPLayoutItemCheck,
    UPLayoutItemPrivacy,
    UPLayoutItemSuper
};


@interface UPLayoutConstraint : NSObject
/**
 授权页布局类，使用Autolayout处理。用法参考系统类NSLayoutConstraint 以及示例demo。
 */

@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) UPLayoutItem item;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat constant;

/**
 相对父视图的布局约束

 @param attr1 约束类型
 @param relation 与参照视图之间的约束关系
 @param item 参照item
 @param attr2 参照item约束类型
 @param multiplier 乘数
 @param c 常量
 @return UPLayoutConstraint布局对象
 */
+(instancetype)constraintWithAttribute:(NSLayoutAttribute)attr1
                             relatedBy:(NSLayoutRelation)relation
                                toItem:(UPLayoutItem)item
                             attribute:(NSLayoutAttribute)attr2
                            multiplier:(CGFloat)multiplier
                              constant:(CGFloat)c;
@end


@interface UPUIConfig : NSObject

/**
 授权页面的各个控件的Y轴默认值都是以375*667屏幕为基准 系数 ： 当前屏幕高度/667
 1、当设置Y轴并有效时 偏移量OffsetY属于相对导航栏的绝对Y值
 2、（负数且超出当前屏幕无效）为保证各个屏幕适配,请自行设置好Y轴在屏幕上的比例（推荐:当前屏幕高度/667）
 */

/*----------------------------------------授权页面-----------------------------------*/
//MARK:导航栏*************

/**导航栏颜色*/
@property (nonatomic,strong) UIColor *navColor;
/**授权页 preferred status bar style，取代barStyle参数 */
@property (nonatomic,assign) UIStatusBarStyle preferredStatusBarStyle;
/**协议页 preferred status bar style，取代barStyle参数 */
@property (nonatomic,assign) UIStatusBarStyle agreementPreferredStatusBarStyle;
/**导航栏标题*/
@property (nonatomic,copy) NSAttributedString *navText;
/**导航栏默认返回按钮隐藏，默认不隐藏*/
@property (nonatomic,assign) BOOL navReturnHidden;
/**导航返回按钮图标*/
@property (nonatomic,strong) UIImage *navReturnImg;
/*导航栏返回按钮图片缩进,默认为UIEdgeInsetsZero*/
@property (nonatomic,assign) UIEdgeInsets navReturnImageEdgeInsets;
/**导航栏右侧自定义控件*/
@property (nonatomic,strong) UIBarButtonItem *navControl;
/**是否隐藏导航栏（适配全屏图片）*/
@property (nonatomic,assign) BOOL navCustom;
/**导航栏是否透明，默认不透明。此参数和navBarBackGroundImage冲突，应避免同时使用*/
@property (nonatomic,assign) BOOL navTransparent;
/**导航栏背景图片.此参数和navTransparent冲突，应避免同时使用*/
@property (nonatomic,strong) UIImage *navBarBackGroundImage;
/**导航栏分割线是否隐藏，默认隐藏*/
@property (nonatomic,assign) BOOL navDividingLineHidden;

/**竖屏情况下，是否隐藏状态栏。默认NO
 在项目的Info.plist文件里设置UIViewControllerBasedStatusBarAppearance为YES
 注意：弹窗模式下无效，是否隐藏由外部控制器控制*/
@property (nonatomic,assign) BOOL prefersStatusBarHidden;




//MARK:图片设置************
/**授权界面背景图片*/
@property (nonatomic,strong) UIImage *authPageBackgroundImage;
/**LOGO图片*/
@property (nonatomic,strong) UIImage *logoImg;
/*LOGO图片布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* logoConstraints;
/*LOGO图片 横屏布局，横屏时优先级高于logoConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* logoHorizontalConstraints;
/**LOGO图片隐藏*/
@property (nonatomic,assign) BOOL logoHidden;

//MARK:登录按钮************

/**登录按钮文本*/
@property (nonatomic,strong) NSString *logBtnText;
/**登录按钮字体，默认跟随系统*/
@property (nonatomic,strong) UIFont *logBtnFont;
/*登录按钮布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* logBtnConstraints;
/*登录按钮 横屏布局，横屏时优先级高于logBtnConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* logBtnHorizontalConstraints;
/**登录按钮文本颜色*/
@property (nonatomic,strong) UIColor *logBtnTextColor;
/**登录按钮背景图片添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
 注意:当customPrivacyAlertViewBlock不为空，并且隐私栏为选中时，失效状态的图片设置无效
 */
@property (nonatomic,copy) NSArray *logBtnImgs;

//MARK:号码框设置************

/**手机号码字体颜色*/
@property (nonatomic,strong) UIColor *numberColor;
/**手机号码字体大小*/
@property (nonatomic,assign) CGFloat numberSize;
/*手机号码字体，优先级高于numberSize*/
@property (nonatomic,strong) UIFont *numberFont;
/*号码栏布局 宽高自适应，不需要设置*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* numberConstraints;
/*号码栏 横屏布局,横屏时优先级高于numberConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* numberHorizontalConstraints;

//MARK:隐私条款************

/**复选框未选中时图片*/
@property (nonatomic,strong) UIImage *uncheckedImg;
/**复选框选中时图片*/
@property (nonatomic,strong) UIImage *checkedImg;
/*复选框是否隐藏，默认不隐藏*/
@property (nonatomic,assign) BOOL checkViewHidden;
/*复选框布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* checkViewConstraints;
/*复选框 横屏布局，横屏优先级高于checkViewConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* checkViewHorizontalConstraints;

/**隐私条款一:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray *appPrivacyOne;
/**隐私条款二:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray *appPrivacyTwo;
/**隐私条款名称颜色
 @[基础文字颜色,条款颜色]
 */
@property (nonatomic,strong) NSArray *appPrivacyColor;
/**隐私条款文本对齐方式，目前仅支持 left、center*/
@property (nonatomic,assign) NSTextAlignment privacyTextAlignment;
/**隐私条款字体大小，默认12*/
@property (nonatomic,assign) CGFloat privacyTextFontSize;
/**隐私条款是否显示书名号，默认不显示*/
@property (nonatomic,assign) BOOL privacyShowBookSymbol;
/**隐私条款行距，默认跟随系统*/
@property (nonatomic,assign) CGFloat privacyLineSpacing;
/**隐私条款拼接文本数组，数组限制4个NSString对象，否则无效
 默认文本1为：”登录即同意“，文本2:”和“，文本3：”、“，文本4：”并使用本机号码登录“
 设置后，隐私协议栏文本修改为 文本1 + 运营商默认协议名称 + 文本2 + 开发者协议名称1 + 文本3 + 开发者协议文本2 + 文本4
 */
@property (nonatomic,strong) NSArray <NSString *>* privacyComponents;
/*隐私条款布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* privacyConstraints;
/*隐私条款 横屏布局，横屏下优先级高于privacyConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* privacyHorizontalConstraints;
/**隐私条款check框默认状态 默认:NO */
@property (nonatomic,assign) BOOL privacyState;
/*
 当自定义Alert view,当隐私条款未选中时,点击登录按钮时回调
 当此参数存在时,未选中隐私条款的情况下，登录按钮可以被点击
 block内部参数为自定义Alert view可被添加的控制器，详细用法可参见示例demo
 开发者可以根据给出的VC、appPrivacys自定义协议勾选提醒二次弹窗
 然后利用loginAction进行登录
 注意：当此参数不为空并且隐私栏为选中的情况下，logBtnImgs失效状态图片设置无效
 */
@property (nonatomic, strong) UPPrivacyAlertViewBlock customPrivacyAlertViewBlock;


//MARK:slogan************
/*slogan布局，宽高自适应不需要设置*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* sloganConstraints;
/*slogan 横屏布局,横屏下优先级高于sloganConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* sloganHorizontalConstraints;
/**slogan文字颜色*/
@property (nonatomic,strong) UIColor *sloganTextColor;
/*slogan文字font,默认12*/
@property (nonatomic,strong) UIFont *sloganFont;

/*默认loading布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* loadingConstraints;
/*默认loading 横屏布局，横屏下优先级高于loadingConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint *>* loadingHorizontalConstraints;
/*自定义loading view,当授权页点击登录按钮时回调
 当此参数存在时,默认loading view不会显示,需开发者自行设计loading view
 block内部参数为自定义loading view可被添加的父视图，详细用法可参见示例demo
 */
@property (nonatomic,copy) void(^customLoadingViewBlock)(UIView * View);



/*弹窗样式设置*/
/*是否弹窗，默认no*/
@property (nonatomic, assign) BOOL showWindow;
/*弹框内部背景图片*/
@property (nonatomic, strong) UIImage *windowBackgroundImage;
/*弹窗外侧 透明度  0~1.0*/
@property (nonatomic, assign) CGFloat windowBackgroundAlpha;
/*弹窗圆角数值*/
@property (nonatomic, assign) CGFloat windowCornerRadius;
/*弹窗布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* windowConstraints;
/*弹窗横屏布局，横屏下优先级高于windowConstraints*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* windowHorizontalConstraints;


/*弹窗close按钮图片 @[普通状态图片，高亮状态图片]*/
@property (nonatomic, copy) NSArray <UIImage *>*windowCloseBtnImgs;
/*弹窗close按钮布局*/
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* windowCloseBtnConstraints;
/*弹窗close按钮 横屏布局,横屏下优先级高于windowCloseBtnConstraints */
@property (nonatomic, copy) NSArray <UPLayoutConstraint*>* windowCloseBtnHorizontalConstraints;


/*是否使用autoLayout，默认NO。使用UPLayoutConstraint对象布局，需要改成YES*/
@property (nonatomic, assign) BOOL autoLayout;

/*是否支持自动旋转 默认YES。
 注意: 当授权页为弹框样式时,参数无效，是否旋转由当前视图控制器控制 */
@property (nonatomic,assign) BOOL  shouldAutorotate;
/*设置进入授权页的屏幕方向。不支持UIInterfaceOrientationPortraitUpsideDown
 注意:当授权页为弹框样式时,参数无效，屏幕方向由当前视图控制器控制 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/**协议页导航栏背景颜色*/
@property (nonatomic, strong) UIColor *agreementNavBackgroundColor;
/*授权页点击运营商默认协议，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *agreementNavText;
/*授权页点击自定义协议1，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *firstPrivacyAgreementNavText;
/*授权页点击自定义协议2，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *secondPrivacyAgreementNavText;
/*协议页导航栏返回按钮图片*/
@property (nonatomic, strong) UIImage *agreementNavReturnImage;

/**授权页弹出方式,
 弹窗模式下不支持 UIModalTransitionStylePartialCurl*/
@property (nonatomic,assign) UIModalTransitionStyle  modalTransitionStyle;

/*关闭授权页是否有动画。默认YES,有动画。参数仅作用于以下两种情况：
 1、一键登录接口设置登录完成后，自动关闭授权页
 2、用户点击授权页关闭按钮，关闭授权页
 */
@property (nonatomic, assign) BOOL dismissAnimationFlag;
@end



@interface UPAuthConfig : NSObject

/* appKey 必须的,应用唯一的标识. */
@property (nonatomic, copy) NSString *appKey;
/* channel 发布渠道. 可选，默认为空*/
@property (nonatomic, copy) NSString *channel;

/* isProduction 是否生产环境. 如果为开发状态,设置为NO;如果为生产状态,应改为YES.可选，默认为NO */
@property (nonatomic, assign) BOOL isProduction;
/* 设置初始化超时时间，单位毫秒，合法范围是(0,30000]，推荐设置为5000-10000,默认值为10000*/
@property(nonatomic, assign) NSTimeInterval timeout;
/* authBlock 初始化回调，timeout不设置或无效的情况下，默认10s超时*/
@property (nonatomic, copy) void (^authBlock)(NSDictionary *result);

@end


@interface QLHelper : NSObject

+ (void)setupWithConfig:(UPAuthConfig *)config;

/**
 初始化过程是否完成
 * 完成YES, 未完成NO
 */
+ (BOOL)isSetupClient;

/**
 获取手机号校验token

 @param completion token相关信息。
 */
+ (void)getToken:(void (^)(NSDictionary *result))completion;

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
 授权登录。完成后自动隐藏授权页。
 @param vc 当前控制器
 @param completion 登录结果
 */
+ (void)getAuthorizationWithController:(UIViewController *)vc
                            completion:(void (^)(NSDictionary *result))completion;

/**
 授权登录
 @param vc 当前控制器
 @param hide 完成后是否自动隐藏授权页。
 @param completion 登录结果
 */
+ (void)getAuthorizationWithController:(UIViewController *)vc
                                  hide:(BOOL)hide
                            completion:(void (^)(NSDictionary *result))completion;


/**
 授权登录
 @param vc 当前控制器
 @param hide 完成后是否自动隐藏授权页。
 @param completion 登录结果
 @parm  actionBlock 授权页事件触发回调。 type事件类型，content事件描述。详细见文档
 */
+ (void)getAuthorizationWithController:(UIViewController *)vc
                                  hide:(BOOL)hide
                            completion:(void (^)(NSDictionary *result))completion
                           actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock;


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
 @param UIConfig 自定义UI设置。仅使用UPUIConfig类型对象
 */
+ (void)customUIWithConfig:(UPUIConfig *)UIConfig;

/**
 自定义登录页UI样式参数
 @param UIConfig  UIConfig对象实例。仅使用UPUIConfig类型对象
 @param customViewsBlk 添加自定义视图block
*/
+ (void)customUIWithConfig:(UPUIConfig *)UIConfig customViews:(void(^)(UIView *customAreaView))customViewsBlk;


@end

