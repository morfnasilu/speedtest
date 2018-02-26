//
//  SPSpeedViewController.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPThroughputTestViewController.h"
#import "SPInjectorContainer.h"
#import "SPTransferManager.h"
#import "SPSpeedTestManager.h"
#import "SPSpeedTestManagerDelegate.h"

@interface SPThroughputTestViewController ()<SPSpeedTestManagerDelegate> {
    UILabel *_currentsSpeedLabel;
    UILabel *_pickSpeedLabel;
    UILabel *_averageSpeedLabel;
    UILabel *_stateLabel;
}
@end

@implementation SPThroughputTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *latencybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [latencybutton setTitle:@"LatencyTest" forState:UIControlStateNormal];
    [latencybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    latencybutton.translatesAutoresizingMaskIntoConstraints = NO;
    [latencybutton addTarget:self action:@selector(latencyTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latencybutton];
    
    [NSLayoutConstraint constraintWithItem:latencybutton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:latencybutton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100].active = YES;
    [NSLayoutConstraint constraintWithItem:latencybutton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:latencybutton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0].active = YES;
    
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
    
    _currentsSpeedLabel = [UILabel new];
    _currentsSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _currentsSpeedLabel.textColor = [UIColor blueColor];
    _currentsSpeedLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_currentsSpeedLabel];
    
    [NSLayoutConstraint constraintWithItem:_currentsSpeedLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_currentsSpeedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10].active = YES;
    
    _pickSpeedLabel = [UILabel new];
    _pickSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _pickSpeedLabel.textColor = [UIColor blueColor];
    _pickSpeedLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_pickSpeedLabel];
    
    [NSLayoutConstraint constraintWithItem:_pickSpeedLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentsSpeedLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:10].active = YES;
    [NSLayoutConstraint constraintWithItem:_pickSpeedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentsSpeedLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;
    
    
    _averageSpeedLabel = [UILabel new];
    _averageSpeedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _averageSpeedLabel.textColor = [UIColor blueColor];
    _averageSpeedLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_averageSpeedLabel];
    
    [NSLayoutConstraint constraintWithItem:_averageSpeedLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_currentsSpeedLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10].active = YES;
    [NSLayoutConstraint constraintWithItem:_averageSpeedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentsSpeedLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0].active = YES;
    
    
    _stateLabel = [UILabel new];
    _stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stateLabel.textColor = [UIColor blueColor];
    _stateLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_stateLabel];
    
    [NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:_stateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentsSpeedLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10].active = YES;
}


-(void)latencyTest {
    [injectorContainer().speedTestManager runTestWithType:SPSpeedTestManagerStrategyLatency testType:SPSpeedTestManagerTestTypeDownloading delegate:self];
}


-(void)buttonTouch {
    [injectorContainer().speedTestManager runTestWithType:SPSpeedTestManagerStrategySimple testType:SPSpeedTestManagerTestTypeDownloading delegate:self];
}


-(void)testStateChanged:(id<SPSpeedTestProtocol>)test state:(SPSpeedTestState)testState {
    if (testState == SPSpeedTestRunning) {
        _stateLabel.text = @"Running";
    }
    if (testState == SPSpeedTestComplete) {
        _stateLabel.text = @"Test completed";
        return;
    }
    _currentsSpeedLabel.text = [NSByteCountFormatter stringFromByteCount:test.speed countStyle:NSByteCountFormatterCountStyleDecimal];
    _averageSpeedLabel.text = [NSByteCountFormatter stringFromByteCount:test.avarageSpeed countStyle:NSByteCountFormatterCountStyleDecimal];
    _pickSpeedLabel.text = [NSByteCountFormatter stringFromByteCount:test.pickSpeed countStyle:NSByteCountFormatterCountStyleDecimal];
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
