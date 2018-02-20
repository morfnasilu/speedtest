//
//  SPSpeedViewController.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedViewController.h"
#import "SPInjectorContainer.h"
#import "SPTransferManager.h"
#import "SPSpeedTestManager.h"
#import "SPSpeedTestManagerDelegate.h"

@interface SPSpeedViewController ()<SPSpeedTestManagerDelegate> {
    UILabel *_label;
    UILabel *_stateLabel;
}
@end

@implementation SPSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
    
    _label = [UILabel new];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.textColor = [UIColor blueColor];
    _label.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_label];
    
    [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10].active = YES;
    
    _stateLabel = [UILabel new];
    _stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stateLabel.textColor = [UIColor blueColor];
    _stateLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_stateLabel];
    
    [NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10].active = YES;
}


-(void)buttonTouch {
    [injectorContainer().speedTestManager runTestWithType:SPSpeedTestManagerStrategySimple delegate:self];
}


-(void)testStateChanged:(id<SPSpeedTestProtocol>)test state:(SPSpeedTestState)testState {
    if (test.speed) {
        int i = 0;
        i++;
    }
    if (testState == SPSpeedTestRunning) {
        _label.text = @"Running";
    }
    if (testState == SPSpeedTestComplete) {
        _label.text = @"Test completed";
        return;
    }
    _label.text = [NSByteCountFormatter stringFromByteCount:test.speed countStyle:NSByteCountFormatterCountStyleDecimal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
