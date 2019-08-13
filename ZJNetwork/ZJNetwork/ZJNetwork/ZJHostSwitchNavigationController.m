//
//  ZJHostSwitchNavigationController.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/13.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJHostSwitchNavigationController.h"
#import "ZJHostSwitchController.h"

@interface ZJHostSwitchNavigationController ()


@end

@implementation ZJHostSwitchNavigationController

// MARK: - Init

+ (instancetype)controller {
    return [[self alloc] initWithRootViewController:ZJHostSwitchController.new];
}





@end
