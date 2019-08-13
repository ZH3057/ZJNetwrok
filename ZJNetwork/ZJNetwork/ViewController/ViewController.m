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

- (void)dealloc {
    [self.requestTask cancelRequestAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZJRequestTask *requestTask = [ZJRequestTask new];
    requestTask.delegate = self;
    //requestTask.method = ZJRequestMethod_POST;
    [requestTask fetchDataWithPath:@"https://www.baidu.com/demo/test/path" parameters:@{@"test1234" : @(1234)}];
    self.requestTask = requestTask;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - ZJRequestTaskDelegate

- (void)requestTask:(ZJRequestTask *)requestTask successWithResponse:(NSURLResponse *)response responseObject:(id)responseObject {
    NSLog(@"%@", requestTask.requestInfoString);
    
    NSLog(@"%@", requestTask.responseInfoString);
}

- (void)requestTask:(ZJRequestTask *)requestTask failWithResponse:(NSURLResponse *)response error:(NSError *)error {
    
}


@end
