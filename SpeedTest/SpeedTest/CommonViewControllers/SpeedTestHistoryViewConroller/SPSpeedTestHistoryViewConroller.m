//
//  SPSpeedTestHistoryViewConroller.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestHistoryViewConroller.h"
#import "SPSpeedTestHistoryTableViewDataSourse.h"
#import "SPSpeedTestHistoryTableViewCell.h"

@interface SPSpeedTestHistoryViewConroller ()<UITableViewDelegate> {
    UITableView *_tableView;
    SPSpeedTestHistoryTableViewDataSourse *_dataSource;
}
@end

@implementation SPSpeedTestHistoryViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}


-(void)setupView {
    _tableView = [[UITableView alloc] init];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _dataSource = [[SPSpeedTestHistoryTableViewDataSourse alloc] initWithTableView:_tableView];
    _tableView.dataSource = _dataSource;
    _tableView.delegate = self;
    [self registerCells];
    [self.view addSubview:_tableView];
    
    [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}


-(void)registerCells {
    [_tableView registerClass:[SPSpeedTestHistoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SPSpeedTestHistoryTableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
