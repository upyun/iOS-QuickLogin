//
//  ViewController.m
//  LoginTest
//
//  Created by lingang on 2020/2/17.
//  Copyright © 2020 upyun. All rights reserved.
//

#import "ViewController.h"
#import <YYKit/YYKit.h>
#import <QuickLogin/QLHelper.h>


@interface ViewController ()

@property(nonatomic, strong) UIButton *loginButton;

@property(nonatomic, strong) UIButton *otherButton;

@property(nonatomic, strong) UPUIConfig *config;

@property(nonatomic, strong) UIButton *btn6;

@property(nonatomic, strong) UIView *customAreaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customFullScreenUI];
//    [self customWindowUI];
    [self setupView];
}

-(void)setupView {
    self.loginButton = [self createButton:@"一键登录"];
    [self.view addSubview:self.loginButton];
}

- (UIButton *)createButton:(NSString *)title {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    btn.backgroundColor = UIColor.redColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.loginButton.center = CGPointMake(self.view.center.x, self.view.center.y);
}

-(void)click:(UIButton *)btn {

    if (self.loginButton == btn) {
        @weakify(self);
        [QLHelper getAuthorizationWithController:self hide:YES animated:YES timeout:15*1000 completion:^(NSDictionary *result) {
            @strongify(self);
            NSLog(@"一键登录 result:%@", result);
            NSString *token = result[@"loginToken"];
            NSInteger code = [result[@"code"] integerValue];

            if (token) {
                /// 拿到的 token 进行校验, 处理
                /// 注意. 建议这里是自己的服务与 又拍接口交互, 解密, 返回手机号, 这个方法仅做演示,不做任何安全保证
                [self checkToken:token];
            } else if (code == 6006) {
                /// 预取号信息过期，请重新预取号
            } else {
                /// 取消了.关闭了弹窗
            }

        } actionBlock:^(NSInteger type, NSString *content) {
            NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);
            
        }];
    }

    if (self.otherButton == btn) {
        NSLog(@"其他方式登录, UI 自己实现");
        UIViewController *topVC =  [self topViewController];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = UIColor.whiteColor;
        [topVC.navigationController pushViewController:vc animated:YES];
    }

}
/*设置弹窗样式UI*/
- (void)customWindowUI{
    UPUIConfig *config = [[UPUIConfig alloc] init];
    config.navCustom = YES;
    config.autoLayout = YES;
    config.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;

    //弹框
    config.showWindow = YES;

    config.windowBackgroundAlpha = 0.3;
    config.windowCornerRadius = 6;

    config.sloganTextColor = [UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0];
    config.privacyComponents = @[@"我已阅读并同意",@"文本2",@"文本3",@",并授权又拍获取本机号码"];
    CGFloat windowW = 320;
    CGFloat windowH = 250;
    UPLayoutConstraint *windowConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *windowConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    UPLayoutConstraint *windowConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
    UPLayoutConstraint *windowConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
    config.windowConstraints = @[windowConstraintY,windowConstraintH,windowConstraintX,windowConstraintW];

    UPLayoutConstraint *windowConstraintW1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:480];
    UPLayoutConstraint *windowConstraintH1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:250];


    config.windowHorizontalConstraints =@[windowConstraintY,windowConstraintH1,windowConstraintX,windowConstraintW1];

    //弹窗close按钮
    UIImage *window_close_nor_image = [UIImage imageNamed:@"icon_close"];
    UIImage *window_close_hig_image = [UIImage imageNamed:@"icon_close"];
    if (window_close_nor_image && window_close_hig_image) {
        config.windowCloseBtnImgs = @[window_close_nor_image, window_close_hig_image];
    }
    CGFloat windowCloseBtnWidth = 30;
    CGFloat windowCloseBtnHeight = 30;
    UPLayoutConstraint *windowCloseBtnConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    UPLayoutConstraint *windowCloseBtnConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    UPLayoutConstraint *windowCloseBtnConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowCloseBtnWidth];
    UPLayoutConstraint *windowCloseBtnConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowCloseBtnHeight];
    config.windowCloseBtnConstraints = @[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];


    //logo
    config.logoImg = [UIImage imageNamed:@"icon_upyun"];
    CGFloat logoWidth = 105;
    CGFloat logoHeight = 26;
    UPLayoutConstraint *logoConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *logoConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:40];
    UPLayoutConstraint *logoConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    UPLayoutConstraint *logoConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];

    UPLayoutConstraint *logoConstraintLeft = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:16];

    UPLayoutConstraint *logoConstraintTop = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:11];

    config.logoHorizontalConstraints = @[logoConstraintLeft,logoConstraintTop,logoConstraintW,logoConstraintH];


    //号码栏
    UPLayoutConstraint *numberConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *numberConstraintY = [UPLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:14];

    UPLayoutConstraint *numberConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:28];
    UPLayoutConstraint *numberConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:200];

    UPLayoutConstraint *numberConstraintY1 = [UPLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:39];

    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintH,numberConstraintW];
    config.numberHorizontalConstraints = @[numberConstraintX,numberConstraintY1,numberConstraintH,numberConstraintW];

    //slogan展示
    UPLayoutConstraint *sloganConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *sloganConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNumber attribute:NSLayoutAttributeBottom   multiplier:1 constant:4];
    UPLayoutConstraint *sloganConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:17];
    UPLayoutConstraint *sloganConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:200];

    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];

    //登录按钮
    UIImage *login_nor_image = [UIImage imageNamed:@"icon_login"];
    UIImage *login_dis_image = [UIImage imageNamed:@"icon_login"];
    UIImage *login_hig_image = [UIImage imageNamed:@"icon_login"];
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    config.logBtnText = @"一键登录";
    CGFloat loginButtonWidth = 220;
    CGFloat loginButtonHeight = 38;
    UPLayoutConstraint *loginConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *loginConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    UPLayoutConstraint *loginConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    UPLayoutConstraint *loginConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    UPLayoutConstraint *loginConstraintY1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:13];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = @[loginConstraintX,loginConstraintY1,loginConstraintW,loginConstraintH];
    //勾选框
    config.checkViewHidden = YES;
    //隐私
    config.privacyState = YES;
    config.privacyTextFontSize = 10;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[[UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0],[UIColor colorWithRed:137/255.0 green:152/255.0 blue:255/255.0 alpha:1/1.0]];
    UPLayoutConstraint *privacyConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *privacyConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:180];
    UPLayoutConstraint *privacyConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-21];
    UPLayoutConstraint *privacyConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:32];
    UPLayoutConstraint *privacyConstraintY1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-23];
    UPLayoutConstraint *privacyConstraintH1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:14];
    UPLayoutConstraint *privacyConstraintW1 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:400];
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintY,privacyConstraintH,privacyConstraintW];
    config.privacyHorizontalConstraints = @[privacyConstraintX,privacyConstraintY1,privacyConstraintH1,privacyConstraintW1];
    //loading
    UPLayoutConstraint *loadingConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *loadingConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    UPLayoutConstraint *loadingConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    UPLayoutConstraint *loadingConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];

    [QLHelper customUIWithConfig:config customViews:^(UIView *customAreaView) {

    }];

}

/*设置全屏样式UI*/
- (void)customFullScreenUI {

    UPUIConfig *config = [[UPUIConfig alloc] init];
    config.navCustom = YES;
    config.autoLayout = YES;

    config.navText = [[NSAttributedString alloc]initWithString:@"又拍云一键登录" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];

    config.privacyTextAlignment = NSTextAlignmentLeft;

    //logo
    config.logoImg = [UIImage imageNamed:@"icon_upyun"];
    CGFloat logoWidth = config.logoImg.size.width?:100;
    CGFloat logoHeight = logoWidth;

    CGFloat logoY = 104;
    if (@available(iOS 11.0, *)) {
        logoY  += self.view.safeAreaInsets.bottom;
    }

    UPLayoutConstraint *logoConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *logoConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:logoY];
    UPLayoutConstraint *logoConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    UPLayoutConstraint *logoConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    config.logoHorizontalConstraints = config.logoConstraints;



    //号码栏
    UPLayoutConstraint *numberConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *numberConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-55];
    UPLayoutConstraint *numberConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    UPLayoutConstraint *numberConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
    config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
    config.numberHorizontalConstraints = config.numberConstraints;

    //slogan展示
    UPLayoutConstraint *sloganConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *sloganConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
    UPLayoutConstraint *sloganConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    UPLayoutConstraint *sloganConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
    config.sloganHorizontalConstraints = config.sloganConstraints;


    //登录按钮
    UIImage *login_nor_image = [UIImage imageNamed:@"icon_login"];
    UIImage *login_dis_image = [UIImage imageNamed:@"icon_login"];
    UIImage *login_hig_image = [UIImage imageNamed:@"icon_login"];
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    CGFloat loginButtonWidth = login_nor_image.size.width?:100;
    CGFloat loginButtonHeight = login_nor_image.size.height ?:100;
    UPLayoutConstraint *loginConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *loginConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:30];
    UPLayoutConstraint *loginConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    UPLayoutConstraint *loginConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = config.logBtnConstraints;

    //勾选框
    UIImage *uncheckedImg = [UIImage imageNamed:@"icon_uncheck"];
    UIImage *checkedImg = [UIImage imageNamed:@"icon_check"];
    CGFloat checkViewWidth = 16;
    CGFloat checkViewHeight = 16;
    config.uncheckedImg = uncheckedImg;
    config.checkedImg = checkedImg;
    UPLayoutConstraint *checkViewConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    UPLayoutConstraint *checkViewConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    UPLayoutConstraint *checkViewConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    UPLayoutConstraint *checkViewConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
    config.checkViewHorizontalConstraints = config.checkViewConstraints;


    //隐私
    CGFloat spacing = checkViewWidth + 20 + 5;
    config.privacyState = YES;


    UPLayoutConstraint *privacyConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
    UPLayoutConstraint *privacyConstraintX2 = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
    UPLayoutConstraint *privacyConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    UPLayoutConstraint *privacyConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
    config.privacyHorizontalConstraints = config.privacyConstraints;


    //loading
    UPLayoutConstraint *loadingConstraintX = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    UPLayoutConstraint *loadingConstraintY = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    UPLayoutConstraint *loadingConstraintW = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    UPLayoutConstraint *loadingConstraintH = [UPLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:UPLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    config.loadingHorizontalConstraints = config.loadingConstraints;

    config.privacyComponents = @[@"我已阅读并同意",@"文本2",@"文本3",@",并授权又拍获取本机号码"];
    config.privacyShowBookSymbol = YES;

    config.logBtnText = @"一键登录";
    config.logBtnTextColor = [UIColor whiteColor];

    UIColor *color = [UIColor colorWithRed:26/255.0 green:151/255.0 blue:255/255.0 alpha:1];

    self.config = config;

    @weakify(self);
    [QLHelper customUIWithConfig:config customViews:^(UIView *customAreaView) {
        @strongify(self);
        self.otherButton = [self createButton:@"其他方式"];
        self.otherButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.otherButton.backgroundColor = UIColor.clearColor;
        [self.otherButton setTitleColor:color forState:UIControlStateNormal];
        CGFloat x = (kScreenWidth - 78)/2;
        CGFloat y = (1 - 280.0/677) * kScreenHeight;
        self.otherButton.frame = CGRectMake(x, y, 73, 30);
        [customAreaView addSubview:self.otherButton];
    }];
}


- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark - Check Token
/// 注意. 建议这里是自己的服务与 又拍接口交互, 解密, 返回手机号, 这个方法仅做演示,不做任何安全保证
-(void)checkToken:(NSString *)token {
    NSError *error;

    NSString *key = @"379ee76164528cbc7af1c152";
    NSString *secret = @"00c0b789ea9ae1e0ac9d1836";
    NSString *auth = [self base64EncodeFromString:[NSString stringWithFormat:@"%@:%@", key, secret]];
    auth = [NSString stringWithFormat:@"Basic %@", auth];


    NSURLSession *session = [NSURLSession sharedSession];

    NSURL *url = [NSURL URLWithString:@"https://sim-api.upyun.com/login/token/verify"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:auth forHTTPHeaderField:@"Authorization"];

    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = @{@"loginToken":token, @"exID":@"3333333"};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];


    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSString *str2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSLog(@"\n data = %@\n ---------\n  ,str2 = %@ \n ",data, str2 );
        NSLog(@"error===%@", error);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"result====%@", result);
        NSString *phone = result[@"phone"];
        NSLog(@"将 phone 用 RSA 解密就能获取手机号, 建议这个 checkToken: 服务端处理");
    }];

    [postDataTask resume];
}

- (NSString *)base64EncodeFromString:(NSString *)string {
    NSData *stingData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [stingData base64EncodedDataWithOptions:0];
    NSString *base64String = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    if (!base64String) {
        NSLog(@"base64===  %@ %@", string, base64Data);
    }
    return base64String;
}



@end
