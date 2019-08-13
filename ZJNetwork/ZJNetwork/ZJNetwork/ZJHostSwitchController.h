//
//  ZJHostSwitchController.h
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/13.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJHostSwitchController : UIViewController

@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *environment;

@end

NS_ASSUME_NONNULL_END
