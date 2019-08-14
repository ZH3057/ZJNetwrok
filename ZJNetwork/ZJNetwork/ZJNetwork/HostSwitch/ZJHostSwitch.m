//
//  ZJHostSwitch.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/13.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJHostSwitch.h"
#import "ZJHostSwitchNavigationController.h"
#import "ZJHostSwitchController.h"

static CGFloat const kLeanProportion = 8/55.0;
static CGFloat const kVerticalMargin = 15;


@interface ZJHostSwitch ()

@property (nonatomic, strong) UIWindow *hostWindow;
@property (nonatomic, strong) ZJHostSwitchNavigationController *controller;
@property (nonatomic, strong) ZJHostSwitchController *hostController;
@property (nonatomic, assign) BOOL isShowHostController;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation ZJHostSwitch

#if DEBUG

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self shareInstance].hostWindow.hidden = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    NSString *title = [NSUserDefaults.standardUserDefaults objectForKey:@"kHostUrlSaveKey"];
    if (!title.length)  {
        title = @"开发";
        [NSUserDefaults.standardUserDefaults setObject:title forKey:@"kHostUrlSaveKey"];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    
    [self shareInstance].hostController = (ZJHostSwitchController *)[self shareInstance].controller.topViewController;
    [self shareInstance].host = [self shareInstance].hostController.host;
    NSLog(@"%@", [self shareInstance].host);
    [self shareInstance].titleLabel.text = title;
}

#endif

static ZJHostSwitch * _instance = nil;

+ (ZJHostSwitch *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZJHostSwitch alloc] init];
        [NSNotificationCenter.defaultCenter addObserver:_instance selector:@selector(hostSwitchControllerDismiss:) name:@"kHostSwitchControllerDismissNotification" object:nil];
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (UIWindow *)hostWindow {
    if (!_hostWindow) {
        _hostWindow = [[UIWindow alloc] initWithFrame:CGRectMake(-kLeanProportion * 55, 100, 55, 55)];
        _hostWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _hostWindow.backgroundColor = UIColor.cyanColor;
        _hostWindow.alpha = .4;
        _hostWindow.layer.borderColor = UIColor.orangeColor.CGColor;
        _hostWindow.layer.borderWidth = 1.0;
        _hostWindow.layer.cornerRadius = 55 * 0.5;
        _hostWindow.clipsToBounds = YES;
        _hostWindow.hidden = NO;
        _hostWindow.rootViewController = UIViewController.new;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delaysTouchesBegan = YES;
        [_hostWindow addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_hostWindow addGestureRecognizer:tap];
        
        self.titleLabel.frame = _hostWindow.bounds;
        [_hostWindow addSubview:self.titleLabel];
        
    }
    return _hostWindow;
}

- (ZJHostSwitchNavigationController *)controller {
    if (!_controller) {
        _controller = ZJHostSwitchNavigationController.controller;
    }
    return _controller;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)p {
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if (p.state == UIGestureRecognizerStateBegan) {
        self.hostWindow.alpha = 1;
    } else if (p.state == UIGestureRecognizerStateChanged) {
        
        self.hostWindow.center = CGPointMake(panPoint.x, panPoint.y);
        
    } else if (p.state == UIGestureRecognizerStateEnded ||
               p.state == UIGestureRecognizerStateCancelled) {
        
        self.hostWindow.alpha = .4;
        
        CGFloat ballWidth = self.hostWindow.frame.size.width;
        CGFloat ballHeight = self.hostWindow.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = minSpace = MIN(MIN(MIN(top, left), bottom), right);
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < kVerticalMargin + ballHeight / 2.0) {
            targetY = kVerticalMargin + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - kVerticalMargin)) {
            targetY = screenHeight - ballHeight / 2.0 - kVerticalMargin;
        }else{
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace = (0.5 - kLeanProportion) * ballWidth;
        CGFloat centerYSpace = (0.5 - kLeanProportion) * ballHeight;
        
        if (minSpace == left) {
            newCenter = CGPointMake(centerXSpace, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, centerYSpace);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - centerYSpace);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            self.hostWindow.center = newCenter;
        }];
    } else {
        
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    
    self.isShowHostController = !self.isShowHostController;
    
    if (self.isShowHostController) {
        UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
        [appWindow.rootViewController presentViewController:self.controller animated:YES completion:nil];
    } else {
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)hostSwitchControllerDismiss:(NSNotification *)notification {
    self.isShowHostController = NO;
    self.host = self.hostController.host;
    self.titleLabel.text = self.hostController.environment;
}

+ (NSString *)currentHost {
    return [self shareInstance].host;
}


@end
