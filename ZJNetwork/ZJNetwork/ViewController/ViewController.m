//
//  ViewController.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2018/6/21.
//  Copyright © 2018年 Jun Zhou. All rights reserved.
//

#import "ViewController.h"
#import "ZJRequestTask.h"

@interface ViewController () <ZJRequestTaskDelegate>

@property (nonatomic, strong) ZJRequestTask *requestTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJRequestTask *requestTask = [ZJRequestTask new];
    requestTask.delegate = self;
    //requestTask.method = ZJRequestMethod_POST;
    [requestTask fetchDataWithPath:@"https://betassapinew.knowbox.cn:9002/teacher/homework-new/homework-list?v=4.1.68&s=iPhoneRCTeacher&sig=AC55P1CAZPZ8PYKZ5Z587G8PZ41GJQDD&apiVersion=3&deviceVersion=12.4&minReportId=0&channel=AppStore&minHomeworkId=0&version=4168&deviceId=F667EE91-15CF-4414-927C-92E665FF1E03&source=iPhoneRCTeacher&deviceType=iOS%20x86_64%20Simulator&minMatchId=0&platform=iOS&minChineseReportId=0&appName=RCTeacher&isFirst=1&token=OBhZO_96r0wi2_wf0NjSm5iKiLv5sVpM6CsrQppYMOrx0BCDkdZNncTSG1wNVOIQcguI-hJYIkTT3eDLuNBQQExWA6le_uoaMOGCzWbEoU8/&appVersion=4.1.68&minExamId=0&minEnglishReportId=0&minGroupClassId=0" parameters:@{@"test1234" : @(1234)}];
    self.requestTask = requestTask;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestTask:(ZJRequestTask *)requestTask successWithResponse:(NSURLResponse *)response responseObject:(id)responseObject {
    
}

- (void)requestTask:(ZJRequestTask *)requestTask failWithResponse:(NSURLResponse *)response error:(NSError *)error {
    
}


@end
