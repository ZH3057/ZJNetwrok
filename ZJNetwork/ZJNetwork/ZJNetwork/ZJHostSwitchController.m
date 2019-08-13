//
//  ZJHostSwitchController.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/13.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJHostSwitchController.h"
static NSString * const kHostUrlSaveKey = @"kHostUrlSaveKey";
static NSString * const cellReuseIdentifier = @"UITableViewCell";

@interface ZJHostSwitchController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) NSDictionary<NSString *, NSString *> *hostDictionary;
@property (nonatomic, strong) NSArray<NSString *> *hostlist;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy, readwrite) NSString *host;
@property (nonatomic, copy, readwrite) NSString *environment;

@end

@implementation ZJHostSwitchController

// MARK: - Delloc

- (void)dealloc {
    NSLog(@"%@ delloc", self.class);
    [self removeNotification];
}

// MARK: - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *title = [NSUserDefaults.standardUserDefaults objectForKey:kHostUrlSaveKey];
        if (!title.length)  {
            title = @"开发";
            [NSUserDefaults.standardUserDefaults setObject:title forKey:kHostUrlSaveKey];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
        _environment = title;
        _host = self.hostDictionary[title];
    }
    return self;
}

// MARK: - Getter


- (NSDictionary<NSString *, NSString *> *)hostDictionary {
    if (!_hostDictionary) {
        _hostDictionary = @{
                            @"线上" : @"123",
                            @"预览" : @"123",
                            @"测试" : @"123",
                            @"开发" : @"123",
                            };
    }
    return _hostDictionary;
}

- (NSArray<NSString *> *)hostlist {
    if (!_hostlist) {
        _hostlist = @[
                      @"线上",
                      @"预览",
                      @"测试",
                      @"开发",
                      ];
    }
    return _hostlist;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //[_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _tableView;
}

// MARK: - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self setupSubviews];
    [self addNotification];
}

// MARK: - Config UI

- (void)configUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = self.environment;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

// MARK: - Setup Subviews

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
}

// MARK: - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
}

// MARK: - Action

- (void)dismiss {
    [NSNotificationCenter.defaultCenter postNotificationName:@"kHostSwitchControllerDismissNotification" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - Notification

/// add
- (void)addNotification {
    
}

/// remove mark: call in delloc
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hostlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:cellReuseIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.textLabel sizeToFit];
    cell.textLabel.text = self.hostlist[indexPath.row];
    cell.detailTextLabel.textColor = UIColor.lightGrayColor;
    cell.detailTextLabel.text = self.hostDictionary[self.hostlist[indexPath.row]];
    return cell;
}

// MARK: - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.environment = self.hostlist[indexPath.row];
    self.title = self.environment;
    self.host = self.hostDictionary[self.hostlist[indexPath.row]];
    [NSUserDefaults.standardUserDefaults setObject:self.environment forKey:kHostUrlSaveKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self dismiss];
}

@end
